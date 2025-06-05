import 'dart:async';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/user_drawer.dart';
import 'package:doctors_appointment_application/modules/Admin/AdminDashboard/presentation/widgets/admin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';

class PatientAppointmentHistoryDesktopView extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String patientId;

  const PatientAppointmentHistoryDesktopView({
    super.key,
    required this.patientId,
    required this.userData,
  });

  @override
  State<PatientAppointmentHistoryDesktopView> createState() =>
      _PatientAppointmentHistoryDesktopViewState();
}

class _PatientAppointmentHistoryDesktopViewState
    extends State<PatientAppointmentHistoryDesktopView> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = fetchAppointments();
  }

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    try {
      final response = await supabase
          .from('appointment')
          .select('*, doctors(doctors_name)')
          .eq('patient_id', widget.patientId)
          .order('date', ascending: false)
          .order('time', ascending: false);

      return response.map((appointment) {
        appointment['doctors_name'] =
            appointment['doctors']?['doctors_name'] ?? 'Unknown Doctor';
        return appointment;
      }).toList();
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
      return [];
    }
  }

  String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat.jm().format(parsed);
    } catch (e) {
      return time;
    }
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  Widget buildAppointmentCard(Map<String, dynamic> appointment) {
    final status = appointment['status'];
    final doctor = appointment['doctors_name'];
    final patient = appointment['patient_name'];
    final problem = appointment['problem'] ?? 'No details';
    final date = formatDate(appointment['date'] ?? '');
    final time = formatTime(appointment['time'] ?? '');

    String animationPath = 'assets/pending.json';
    Color statusColor = Colors.orange;
    String statusText = 'PENDING';

    if (status == 'approved') {
      animationPath = 'assets/approved.json';
      statusColor = Colors.green;
      statusText = 'APPROVED';
    } else if (status == 'rejected') {
      animationPath = 'assets/error.json';
      statusColor = Colors.red;
      statusText = 'REJECTED';
    }

    return Container(
      width: 340,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.greenAccent, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Lottie.asset(
              animationPath,
              width: 80,
              height: 80,
              repeat: true,
            ),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 20,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Doctor: Dr $doctor",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("Name: $patient",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("Date: $date"),
                  const SizedBox(height: 4),
                  Text("Time: $time"),
                  const SizedBox(height: 4),
                  Text("Problem: $problem"),
                  const SizedBox(height: 4),
                  Text(
                    "Status: $statusText",
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshAppointments() async {
    final newData = await fetchAppointments();
    setState(() {
      _appointmentsFuture = Future.value(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: UserDrawer(userData: widget.userData),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (context) {
            return UserAppBar(
              userName: '${widget.userData['user_name']}, appointment status',
              onMenuPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAppointments,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No appointment history found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final appointments = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth >= 800) {
                  crossAxisCount = 2;
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: appointments
                          .map((appointment) =>
                              buildAppointmentCard(appointment))
                          .toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
