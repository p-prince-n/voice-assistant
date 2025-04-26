import 'package:animate_do/animate_do.dart';
import 'package:assistant/feature_box.dart';
import 'package:assistant/global_variable.dart';
import 'package:assistant/open_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenServices openServices = OpenServices();
  final FlutterTts flutterTts = FlutterTts();
  String? genratedContent;
  String? genratedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> assistantSpeack(String content) async {
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: BounceInDown(child: Text('Allen')),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ZoomIn(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: GlobalVariable.assistantCircleColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Container(
                          height: 123,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/virtualAssistant.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInRight(
                    child: Visibility(
                      visible: genratedImageUrl == null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 28,
                        ).copyWith(top: 30),
                        decoration: BoxDecoration(
                          border: Border.all(color: GlobalVariable.borderColor),
                          borderRadius: BorderRadius.circular(
                            20,
                          ).copyWith(topLeft: Radius.zero),
                        ),
                        child: Text(
                          genratedContent == null
                              ? 'Good Day, what task can I do for you ?'
                              : genratedContent!,
                          style: TextStyle(
                            fontFamily: 'Cero pro',
                            color: GlobalVariable.mainFontColor,
                            fontSize: genratedContent != null ? 18 : 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (genratedImageUrl != null)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(genratedImageUrl!),
                      ),
                    ),

                  SlideInLeft(
                    child: Visibility(
                      visible:
                          genratedContent == null && genratedImageUrl == null,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5, left: 22),
                        child: Text(
                          'Here are few feature.',
                          style: TextStyle(
                            fontFamily: 'Cero Pro',
                            color: GlobalVariable.mainFontColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        genratedContent == null && genratedImageUrl == null,
                    child: Column(
                      children: [
                        SlideInLeft(
                          delay: Duration(microseconds: start),
                          child: FeatureBox(
                            color: GlobalVariable.firstSuggestionBoxColor,
                            headerText: 'ChatGPt',
                            desc:
                                'A smarter way to stay organized and informed with ChatGPT',
                          ),
                        ),
                        SlideInRight(
                          delay: Duration(milliseconds: start + delay),
                          child: FeatureBox(
                            color: GlobalVariable.secondSuggestionBoxColor,
                            headerText: 'Dall-E',
                            desc:
                                'get insprired and stay creative with your personal assistant powered by Dall-E.',
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + 2 * delay),
                          child: FeatureBox(
                            color: GlobalVariable.thirdSuggestionBoxColor,
                            headerText: 'Smart Voice Assistant.',
                            desc:
                                'Get the best of both worlds with a voice assistant powered by Dall-E and GhatGPT.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    // vertical: 5,
                  ),
                  // margin: EdgeInsets.only(right: 65),
                  height: 45,
                  width: MediaQuery.of(context).size.width * (4.1 / 5),
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      print(value);
                      final speech = await openServices.isArtPromptAPI(value);
                      if (speech.contains('https')) {
                        genratedImageUrl = speech;
                        genratedContent = null;
                        setState(() {});
                      } else {
                        genratedImageUrl = null;
                        genratedContent = speech;
                        setState(() {});
                        await assistantSpeack(speech);
                      }
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 18),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      hintText: 'Search Here....',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              ZoomIn(
                delay: Duration(milliseconds: start + delay),
                child: GestureDetector(
                  onTap: () async {
                    if (await speechToText.hasPermission &&
                        speechToText.isNotListening) {
                      await startListening();
                    } else if (speechToText.isListening) {
                      print(lastWords);
                      final speech = await openServices.isArtPromptAPI(
                        lastWords,
                      );
                      if (speech.contains('https')) {
                        genratedImageUrl = speech;
                        genratedContent = null;
                        setState(() {});
                      } else {
                        genratedImageUrl = null;
                        genratedContent = speech;
                        setState(() {});
                        await assistantSpeack(speech);
                      }

                      await stopListening();
                    } else {
                      initSpeechToText();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 7, bottom: 6),
                    width: MediaQuery.of(context).size.width * (0.7 / 5),
                    height: MediaQuery.of(context).size.width * (0.7 / 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: GlobalVariable.firstSuggestionBoxColor,
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      speechToText.isListening ? Icons.stop : Icons.mic,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
