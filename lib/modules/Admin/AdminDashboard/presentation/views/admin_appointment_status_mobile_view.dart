import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminAppointmentStatusMobileView extends StatefulWidget {
  final String adminId;
  final Map<String, dynamic> userData;

  const AdminAppointmentStatusMobileView({
    Key? key,
    required this.adminId,
    required this.userData,
  }) : super(key: key);

  @override
  State<AdminAppointmentStatusMobileView> createState() =>
      _AdminAppointmentStatusMobileViewState();
}

class _AdminAppointmentStatusMobileViewState
    extends State<AdminAppointmentStatusMobileView> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = fetchAppointments();
  }

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final now = DateTime.now();
    final startTime = now.subtract(const Duration(hours: 48)); // 48 hours ago

    print("📌 Admin ID: ${widget.adminId}");

    try {
      final response = await supabase
          .from('appointment')
          .select()
          .eq('admin_id', widget.adminId)
          .order('date', ascending: true)
          .order('time', ascending: true);

      print("📥 Raw Supabase response: $response");

      final appointments = List<Map<String, dynamic>>.from(response);

      print("✅ Total appointments fetched: ${appointments.length}");

      List<Map<String, dynamic>> filteredAppointments = [];

      for (var appointment in appointments) {
        try {
          print("🔍 Processing appointment: ${appointment['appointment_id']}");

          final dateString = appointment['date'];
          final timeString = appointment['time'];

          print("🗓 Date string: $dateString");
          print("⏰ Time string: $timeString");

          final date = DateTime.tryParse(dateString);
          final time = DateFormat("HH:mm:ss").parse(timeString);

          if (date == null) {
            print(
                "❌ Failed to parse date for appointment: ${appointment['appointment_id']}");
            continue;
          }

          final appointmentDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );

          print("🧾 Appointment DateTime: $appointmentDateTime");

          final status = appointment['status'];
          print("📦 Status: $status");

          // ⏳ Reschedule pending if older than 48 hours
          if (status == 'pending' && appointmentDateTime.isBefore(startTime)) {
            print(
                "🔄 Updating status to rescheduled for ID: ${appointment['appointment_id']}");
            await supabase
                .from('appointment')
                .update({'status': 'rescheduled'}).eq(
                    'appointment_id', appointment['appointment_id']);
          }

          // ✅ Show only recent and valid statuses
          if (appointmentDateTime.isAfter(startTime) &&
              ['pending', 'approved', 'rescheduled', 'rejected']
                  .contains(status)) {
            filteredAppointments.add(appointment);
          }
        } catch (e) {
          print("❗ Error processing appointment: $e");
        }
      }

      // 🧩 Sort by status: pending → approved → rescheduled → rejected
      filteredAppointments.sort((a, b) {
        const statusOrder = {
          'pending': 0,
          'approved': 1,
          'rescheduled': 2,
          'rejected': 3
        };

        final aStatus = statusOrder[a['status']] ?? 99;
        final bStatus = statusOrder[b['status']] ?? 99;

        return aStatus.compareTo(bStatus);
      });

      print(
          "✅ Final filtered appointments count: ${filteredAppointments.length}");
      return filteredAppointments;
    } catch (e) {
      print("❌ Error fetching appointments: $e");
      return [];
    }
  }

  Future<void> updateStatusAndNotify(
    Map<String, dynamic> appointment,
    String newStatus,
  ) async {
    try {
      final phone = appointment['patient_phone'];
      final name = appointment['patient_name'];
      final date = appointment['date'];
      final time = appointment['time'];
      final doctorId = appointment['doctors_id'];

      if (phone == null || phone.toString().isEmpty) {
        _showSnack('Patient phone number is missing');
        return;
      }
      if (name == null || date == null || time == null || doctorId == null) {
        _showSnack('Missing appointment information');
        return;
      }

      // ✅ Update appointment status
      await supabase.from('appointment').update({'status': newStatus}).eq(
          'appointment_id', appointment['appointment_id']);

      final formattedTime = _formatTime(time);
      final formattedDate = date.toString().substring(0, 10);

      // ✅ Fetch location from doctors table
      final doctorData = await supabase
          .from('doctors')
          .select('doctors_location')
          .eq('doctors_id', doctorId)
          .maybeSingle();

      final locationUrl = doctorData?['doctors_location'];
      final locationText =
          locationUrl != null && locationUrl.toString().isNotEmpty
              ? "\n📍 *Location:* $locationUrl"
              : "";

      // ✅ Build WhatsApp message
      final message = newStatus == 'approved'
          ? """
✅ *Appointment Confirmed*

Dear *$name*,

Your appointment has been *successfully confirmed*. We look forward to seeing you!

📅 *Date:* $formattedDate  
🕒 *Time:* $formattedTime
📍  *Location:* $locationText

🧑‍⚕️  *Admin:* ${widget.userData['user_name']}

If you have any questions, feel free to contact us.

_Thank you for choosing our services!_
"""
          : """
❌ *Appointment Declined*

Dear *$name*,

We regret to inform you that your appointment scheduled for:

📅 *Date:* $formattedDate  
🕒 *Time:* $formattedTime
📍  *Location:* $locationText

has been *politely declined* due to unforeseen circumstances.

Please feel free to reschedule at your convenience.

🧑‍⚕️  *Admin:* ${widget.userData['user_name']}

We apologize for the inconvenience.
""";

      final encodedMessage = Uri.encodeComponent(message);
      final whatsappUrl =
          Uri.parse("https://wa.me/$phone?text=$encodedMessage");

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        _showSnack('Could not launch WhatsApp');
      }

      setState(() {
        _appointmentsFuture = fetchAppointments();
      });
    } catch (e) {
      _showSnack('Error updating status: $e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat.jm().format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  static const LinearGradient gradientColor = LinearGradient(
    colors: [Color(0xFF001F54), Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Lottie.asset(
                'assets/not_found.json',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            );
          }

          final appointments = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _appointmentsFuture = fetchAppointments();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final item = appointments[index];
                final status = item['status'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      gradient: gradientColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 6),
                        ),
                      ]),
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['patient_name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _infoLine("Gender", item['gender']),
                        _infoLine("Age", item['age'].toString()),
                        _infoLine("Phone", item['patient_phone']),
                        _infoLine("Problem", item['problem']),
                        _infoLine("Date", item['date'].substring(0, 10)),
                        _infoLine("Time", _formatTime(item['time'])),
                        const SizedBox(height: 8),
                        Text(
                          "Status: $status",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: status == 'approved'
                                ? Colors.green
                                : status == 'rescheduled'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GradientOutlineButton(
                                onPressed: status == 'pending'
                                    ? () =>
                                        updateStatusAndNotify(item, 'approved')
                                    : null,
                                label: "Approve",
                                icon: Icons.check_circle,
                                textColor: Colors.green,
                                gradient: gradientColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GradientOutlineButton(
                                onPressed: status == 'pending'
                                    ? () => updateStatusAndNotify(
                                        item, 'rescheduled')
                                    : null,
                                label: "Reschedule",
                                icon: Icons.cancel,
                                textColor: Colors.red,
                                gradient: gradientColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}

class GradientOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final Color textColor;
  final Gradient gradient;

  const GradientOutlineButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.textColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: textColor, size: 18),
            label: Text(label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
