import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Job {
  final String image;
  final String created_at;
  final String updated_at;

  Job({required this.image, required this.created_at, required this.updated_at});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      image: json['image'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

class JobsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job>? data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {

    //final jobsListAPIUrl = 'https://mock-json-service.glitch.me/';
    final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/PhotoAPI"));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          //Uint8List myImage = data[index].image.contentAsBytes();
            var img = data[index].image;
            img = img.replaceAll('data:image/png;base64,', '');
          return _tile(Image.memory(base64Decode(img)), data[index].created_at);
        });
  }

  ListTile _tile(Image title, String subtitle) => ListTile(
    title: (title),
    subtitle: Text(subtitle),
  );
}