import 'package:chattitude/widgets/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Penting bagi Anda untuk memiliki rencana yang terstruktur dalam kehidupan sehari-hari',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question':
          'Anda tertarik terhadap kegiatan sosial dan pertemuan dengan teman-teman',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question': 'Kejujuran dan integritas dalam hubungan itu penting',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question':
          'Anda dapat menangani konflik atau perbedaan pendapat dalam hubungan',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question':
          ' Anda cukup fleksibel dalam menghadapi perubahan dalam rencana atau situasi yang tidak terduga',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question':
          'Anda dapat mengatur keseimbangan antara bekerja dan beristirahat',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question': 'Anda dapat mengelola stres dalam kehidupan sehari-hari',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question': 'Anda suka mencoba hal-hal baru atau mengambil risiko',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question':
          'Anda mempentingkan kebebasan dalam hubungan, seperti memiliki waktu pribadi dan teman-teman yang terpisah',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
    {
      'question':
          'Anda menganggap dukungan emosional dalam hubungan persahabatan cukup penting',
      'options': ['Tidak Setuju', 'Netral', 'Setuju'],
    },
  ];

  int totalPoints = 0;

  int currentQuestionIndex = 0;

  void handleAnswer(int points) {
    totalPoints += points;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Ketika pengguna selesai menjawab semua pertanyaan, kategorikan hasil berdasarkan totalPoints
      String quizResultCategory = getCategory(totalPoints);

      // Simpan hasil kategori ke Firebase
      saveResultsToFirebase(quizResultCategory);
      showCompletionDialog(context);
    }
  }

  String getCategory(int totalPoints) {
    if (totalPoints >= 10 && totalPoints <= 16) {
      return 'Kategori 1';
    } else if (totalPoints >= 17 && totalPoints <= 23) {
      return 'Kategori 2';
    } else if (totalPoints >= 24 && totalPoints <= 30) {
      return 'Kategori 3';
    } else {
      return 'Kategori Tidak Valid'; // Tambahkan penanganan kesalahan jika diperlukan
    }
  }

  Future<void> saveResultsToFirebase(String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'nilai_quiz': category});
    }
  }

  void showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pertanyaan Selesai'),
          content: Text('Anda telah menyelesaikan semua pertanyaan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Hapus semua tampilan sebelumnya dan arahkan ke CustomNavigationBar
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomNavigationBar(),
                    ),
                    (route) => false);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
            child: Text('Isi Quiz Untuk Menemukan Teman Sefrekuensi')),
      ),
      body: currentQuestionIndex < questions.length
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Tambahkan ruang di atas pertanyaan
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pertanyaan ${currentQuestionIndex + 1}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    questions[currentQuestionIndex]['question'],
                    style: TextStyle(
                      fontSize: 18, // Tambahkan ukuran teks yang lebih besar
                      fontWeight: FontWeight.normal, // Ganti menjadi normal
                    ),
                  ),
                ),
                SizedBox(height: 20), // Tambahkan ruang di bawah pertanyaan
                for (int i = 0;
                    i < questions[currentQuestionIndex]['options'].length;
                    i++)
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20), // Tambahkan margin vertikal
                    child: MaterialButton(
                      minWidth: double.infinity, // Tombol penuh lebar
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Ganti warna tombol
                      textColor: Colors.white, // Ganti warna teks tombol
                      child: Text(
                        questions[currentQuestionIndex]['options'][i],
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        int points = i + 1;
                        handleAnswer(points);
                      },
                    ),
                  ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
