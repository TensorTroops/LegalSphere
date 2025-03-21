// ignore_for_file: deprecated_member_use, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_speech/google_speech.dart' as googleSpeech;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:math';
import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer _audioPlayer = AudioPlayer();
int? _currentlyPlayingIndex; // Track which audio is playing
bool _isPlaying = false; // Track playback state



void main() {
  // Initialize Gemini with the API key
  Gemini.init(apiKey: 'YOUR_GEMINI_API_KEY');

  runApp(const MyApp());

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LegalSphere',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
  Timer? _timer;

  @override
  void initState() {
    _startAnimating();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimating() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: MediaQuery.sizeOf(context).height * height,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomRecordingButton extends StatelessWidget {
  const CustomRecordingButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  final bool isRecording;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50,
      width: 50,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isRecording ? Colors.red : Colors.blue,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center( // Ensures the icon is centered
          child: Icon(
            isRecording ? Icons.stop : Icons.mic,
            color: Colors.white,
            size: 20, // Icon size
          ),
        ),
      ),
    );
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isRecording = false;
  final _record = AudioRecorder();
  final player = AudioPlayer();

  final List<Map<String, dynamic>> _messages = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> documents = [];
  List<Map<String, dynamic>> filteredDocuments = [];
  List<List<num>> documentVectors = [];

  final speechToText = googleSpeech.SpeechToText.viaServiceAccount(
      ServiceAccount.fromString(r'''
      {
      "type": ".....",
      "project_id": "..........",
      "private_key_id": ".........",
      "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
      "client_email": "............",
      "client_id": "......",
      "auth_uri": "......",
      "token_uri": ".......",
      "auth_provider_x509_cert_url": ".......",
      "client_x509_cert_url": "......",
      "universe_domain": "....."
      }
      '''));

  final translator = Translation(
      apiKey: 'YOUR_GOOGLE_TRANSLATE_API_KEY');

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load JSON file from assets
    final jsonString = await DefaultAssetBundle.of(context).loadString(
        'assets/train.json');
    documents = List<Map<String, dynamic>>.from(json.decode(jsonString));
    filteredDocuments =
        documents.where((doc) =>
        doc.containsKey('Description') &&
            doc['Description'] != null).toList();
    // print(documents);


    // Generate embeddings for each document using Gemini
    documentVectors = await Future.wait(filteredDocuments.map((doc) async {
      // print(doc);
      // print("Description: ${doc['Description']}");
      try {
        final embedding = await _embedTextToVector(doc['Description']);
        return embedding;
      } catch (e) {
        return <double>[]; // Handle errors gracefully
      }
    }).toList());




    FlutterNativeSplash.remove();

    //Initialize Google TTS with the access token
    TtsGoogle.init(
      apiKey: "YOUR_API_KEY",
      withLogs: true,
    );
  }

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final response = await translator.translate(
          text: text, to: targetLanguage);
      return response.translatedText;
    } catch (e) {
      return text;
    }
  }

  Future<String> detectLanguage(String text) async {
    if (text == '') {
      return 'en';
    }
    try {
      final response = await translator.detectLang(text: text);
      return response.detectedSourceLanguage;
    } catch (e) {
      return 'en';
    }
  }

  Future<void> _sendMessage(String prompt) async {
    final sourceLanguage = await detectLanguage(prompt);

    final translatedPrompt = sourceLanguage != 'en'
        ? await translateText(prompt, 'en')
        : prompt;


    String extractedText = '';
    if (_selectedImage != null) {
      extractedText = await _sendImageToGemini(_selectedImage!);
    }

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': prompt,
        'image': _selectedImage,
      });
      _selectedImage = null;
    });

    setState(() {
      _messages.add({'sender': 'bot', 'text': "Generating Response...."});
    });

    String combinedPrompt = extractedText.isNotEmpty
        ? "$extractedText $translatedPrompt"
        : translatedPrompt;

    // Find the best match document using cosine similarity
    final bestMatch = await _getBestMatchingDocument(combinedPrompt);


    final customInstr = '''
    You are an expert in analyzing and providing actionable insights based on legal contexts. Your task is to identify the relevant laws under the Bharatiya Nyaya Sanhita (BNS) and the Indian Penal Code (IPC), explain them in simple terms, and, if applicable, provide detailed guidance for filing a case.

       Task:
      1. Applicable Laws:
         - Identify the relevant sections under BNS and IPC that address the situation.
         - Provide the name and section of the law.(explain the law statement in detailed way to the)
         - Summarize the offense or legal provision in simple terms, ensuring clarity for non-legal audiences.
         - Specify whether the offense is "Cognizable" or "Non-Cognizable."
         - State the punishments clearly, including imprisonment terms, fines, or other penalties.
      
      2. Filing a Complaint (If Applicable):
         - Provide a step-by-step guide for filing a legal complaint.
         - Include necessary details such as where to report, what information/documents to prepare, and whom to contact.
         - Provide specific links and helpline numbers, especially for cases involving women, minors, or heinous crimes.
           - Example Resources:
             - National Commission for Women (NCW): Visit [NCW Website](https://ncw.nic.in) or call 1091.
             - Tamil Nadu Helpline: Call 1098 for immediate assistance.
             - State-wise helpline directory: [State Helpline Directory](https://wcd.nic.in/).
      
      3. Actionable Summary:
         - Offer actionable recommendations for safety measures, preserving evidence, and seeking justice.
         - Provide links to legal aid organizations and non-profits for additional support.
         - Ensure that all guidance is specific, concise, and prioritized.
      
       Important Guidelines:
      - Avoid disclaimers or generic explanations about incomplete information.
      - Ensure punishments and penalties provided are accurate and up-to-date as per Indian law.
      - Format the response clearly, using bullet points or numbered lists for ease of understanding.
      - Include helpline details for cases involving women, children, or heinous crimes.''';


    final inputToDeepseek = '''
    
    $customInstr
        
    Current Scenario:
    $combinedPrompt
    
    Matching laws:
    $bestMatch
    ''';

    final response = await _sendMessageDeepseek(inputToDeepseek);




    final cleanedResponse = response.replaceAll(RegExp(r'[\*#]'), '');



    final finalResponse = sourceLanguage != 'en'
        ? await translateText(
        cleanedResponse, sourceLanguage) //substring(0,100)
        : response;


    //final cleanedResponse = finalResponse.replaceAll(RegExp(r'[\*#]'), '');

    setState(() {
      _messages.removeLast();
    });

    setState(() {
      _messages.add({'sender': 'bot', 'text': finalResponse});
    });

    texttoVoice(cleanedResponse, sourceLanguage);
  }

  Future<void> texttoVoice(String s, String lang) async {
    final voicesResponse = await TtsGoogle.getVoices();

    //Print all available voices

    //Pick an English Voice
    final voice = voicesResponse.voices
        .where((element) => element.locale.code.startsWith("$lang-"))
        .toList(growable: false)
        .first;

    final ttsParams = TtsParamsGoogle(
      voice: voice,
      audioFormat: AudioOutputFormatGoogle.mp3,
      text: s,
    );

    final ttsResponse = await TtsGoogle.convertTts(ttsParams);

    final audioBytes = ttsResponse.audio.buffer.asUint8List();

    await player.play(BytesSource(audioBytes));
  }

  Future<String> _sendImageToGemini(File image) async {
    try {
      final result = await Gemini.instance.textAndImage(
        text: '''
        Analyze the given image to determine if it depicts a situation involving harassment, assault, or any scenario that compromises a woman's security or personal safety. Ensure the output is specific and descriptive, suitable for retrieving relevant laws or resources using the RAG model. Follow these steps:

        Detection and Context:
        
        Analyze the image for visual cues indicating harassment, assault, or a violation of personal safety.
        Focus on body language, facial expressions, gestures, and physical dynamics to determine the nature of the situation.
        Output Requirements (if harassment or insecurity is detected):
        
        Category: Classify the scenario into one of the following categories: Assault, Harassment, Sexual Abuse, Eve-Teasing, or Coercion.
        Description: Provide a detailed and concise explanation of the scene, focusing on:
        The emotions and physical state of the woman (e.g., fear, distress, helplessness).
        The nature of the act (e.g., forceful actions, invasion of personal space).
        The dynamics between the individuals involved (e.g., controlling, aggressive, inappropriate).
        Avoid unnecessary or irrelevant details while ensuring clarity about the victim's insecurity.
        General Description (if no harassment/insecurity is detected):
        
        If the image does not depict harassment or insecurity, provide a brief, general description of the image.
        Do not attempt to force a category or include unwarranted inferences.
        Key Guidelines:
        
        Avoid assumptions beyond what is clearly visible in the image.
        Include information about clothing only if it contributes directly to the context of harassment or insecurity.
        The output must prioritize women's security and clearly identify scenarios requiring legal assistance.
        Output Format:
        
        Category: [Choose from Assault, Harassment, Sexual Abuse, Eve-Teasing, Coercion; leave blank for non-harassment images.]
        Description: [Detailed description emphasizing emotions, circumstances, and women's insecurity. For non-harassment images, provide a simple and general description.]

        ''', // Replace with your fixed text prompt
        images: [image.readAsBytesSync()],
      );
      var temp = result?.content?.parts?.last;
      if (temp is TextPart) {
        return temp.text;
      }
      else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<List<num>> _embedTextToVector(String text) async {
    int maxTries = 10;
    while (maxTries > 0) {
      try {
        final response = await Gemini.instance.embedContent(text);
        return response!;
      }
      catch (error) {
        maxTries = maxTries - 1;
      }
    }
    //print("Hi");
    return [];
    // print(response);
  }

  Future<void> _selectImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
          source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Cosine similarity function
  double _cosineSimilarity(List<num> vec1, List<num> vec2) {
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < vec1.length; i++) {
      dotProduct += vec1[i] * vec2[i];
      normA += vec1[i] * vec1[i];
      normB += vec2[i] * vec2[i];
    }

    normA = sqrt(normA);
    normB = sqrt(normB);

    if (normA == 0.0 || normB == 0.0) {
      return 0.0;
    }

    return dotProduct / (normA * normB);
  }

  // Find the best match document using cosine similarity
  Future<String> _getBestMatchingDocument(String query) async {
    final queryVector = await _embedTextToVector(query);

    double highestSimilarity = -10000;
    double sHighestsimilarity = -10000;
    int bestMatchIndex = -1;
    int sBestmatchindex = -1;
    int tBestmatchindex = -1;


    for (int i = 1; i < documentVectors.length; i++) {
      if (documentVectors[i].isEmpty) {
        continue;
      }
      double similarity = _cosineSimilarity(queryVector, documentVectors[i]);
      if (similarity > highestSimilarity) {
        sHighestsimilarity = highestSimilarity;
        highestSimilarity = similarity;
        tBestmatchindex = sBestmatchindex;
        sBestmatchindex = bestMatchIndex;
        bestMatchIndex = i;
      }
      else if (similarity > sHighestsimilarity) {
        sHighestsimilarity = similarity;
        tBestmatchindex = sBestmatchindex;
        sBestmatchindex = i;
      }
      else if (similarity > sHighestsimilarity) {
        tBestmatchindex = i;
      }
    }

    // print("Best match $bestMatchIndex");

    if (bestMatchIndex != -1) {
      return "${filteredDocuments[bestMatchIndex]}\n${filteredDocuments[sBestmatchindex]}\n${filteredDocuments[tBestmatchindex]}"; // Return the best matching document text
    } else {
      return "Not found";
    }
  }

  Future<String> _sendMessageDeepseek(String text) async {
    try {
      // Get the API key from dart-define or use the hardcoded value as fallback
      final apiKey = const String.fromEnvironment('DEEPSEEK_API_KEY',
          defaultValue: 'YOUR_API_KEY');

      // Create DeepSeek API URL and headers
      final url = Uri.parse('https://api.deepseek.com/v1/chat/completions');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      // Prepare request body
      final body = jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {
            'role': 'system',
            'content': text
          }
        ],
        'temperature': 0.7,
        'max_tokens': 1000
      });

      // Make HTTP request
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: Failed to get response from DeepSeek API';
      }
    } on Exception catch (error) {
      return "Deepseek Error: $error";
    }
  }

  Future<void> requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> transcribe(String filePath) async {
    final config = googleSpeech.RecognitionConfig(
        encoding: googleSpeech.AudioEncoding.LINEAR16,
        model: googleSpeech.RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'en-US');

    final audio = await File(filePath).readAsBytes();
    final response = await speechToText.recognize(config, audio);

    final transcript = response.results
        .map((result) => result.alternatives.first.transcript)
        .join('\n');

    setState(() {
      _controller.text = transcript;
    });
  }

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      Directory appDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDir.path}/recorded_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(
        RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: filePath,
      );

      setState(() {
        isRecording = true;
      });

    } else {
    }
  }

  Future<void> _stopRecording() async {
  String? tempPath = await _record.stop(); // Stop recording
  if (tempPath != null) {
    // Get a directory on your laptop (Documents folder)
    Directory downloadsDir = Directory('/storage/emulated/0/Download');
    String newPath = '${downloadsDir.path}/recorded_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    // Copy the recorded file to the new path
    File recordedFile = File(tempPath);
    await recordedFile.copy(newPath);

    setState(() {
      _messages.add({'sender': 'user', 'path': newPath});
      isRecording = false;
    });


    // Show "Generating result..." message
    setState(() {
      _messages.add({'sender': 'bot', 'text': "Generating result..."});
    });

    // Simulate processing before bot replies with an audio
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _messages.removeWhere((msg) => msg['text'] == "Generating result...");
        _messages.add({'sender': 'bot', 'path': 'mal.m4a'});
      });
    });
  }
}





  void handleMicButton() async {
    if (isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }


final _isPlaying = <String, bool>{}; // Tracks playing state for each audio

void _playAudio(String filePath) async {
  if (_isPlaying[filePath] == true) {
    await player.pause();
    setState(() {
      _isPlaying[filePath] = false; // Set to paused
    });
  } else {
    await player.play(
      filePath.contains('1.m4a')
          ? AssetSource('1.m4a')
          : DeviceFileSource(filePath),
    );
    setState(() {
      _isPlaying[filePath] = true; // Set to playing
    });

    // Listen for when playback completes
    player.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying[filePath] = false; // Reset to paused
      });
    });
  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Image.asset('assets/Logo_inv.png', height: 50, width: 50),
          const SizedBox(width: 10),
          const Text(
            'LegalSphere',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    ),
    body: Column(
      children: [
        if (isRecording) const CustomRecordingWaveWidget(), // Show recording animation
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isPlaying = _isPlaying[message['path']] == true;

              return Align(
                alignment: message['sender'] == 'user'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message['image'] != null)
                        Image.file(
                          message['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      if (message['text'] != null)
                        Text(
                          message['text'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      if (message['path'] != null) // Display audio messages
                        GestureDetector(
                          onTap: () => _playAudio(message['path']),
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isPlaying ? Colors.green : Colors.blue, 
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPlaying ? Icons.pause : Icons.audiotrack,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isPlaying ? "Playing..." : "Audio Message",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_selectedImage != null)
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Image.file(
                  _selectedImage!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Image selected",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: _clearSelectedImage,
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your message...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image, color: Colors.white),
                onPressed: _selectImage,
              ),
              CustomRecordingButton(
                isRecording: isRecording,
                onPressed: handleMicButton,
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (_controller.text.isNotEmpty || _selectedImage != null) {
                    _sendMessage(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  bool isPlaying = false;

}