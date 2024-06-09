import 'package:flutter/material.dart';
import 'package:vocab/Model/get_model.dart';
import 'package:vocab/Services/get_services.dart';
import 'package:vocab/widgets/audio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DictionaryModel? dictionaryModel;
  bool isLoading = false;
  String noDataFound = "Get word details here";
  searchContains(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      dictionaryModel = await APIservices.fetchData(word);
    } catch (e) {
      dictionaryModel = null;
      noDataFound = "Meaning cannot be found";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Vocab 📖",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        )),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SearchBar(
              hintText: "Search the word here",
              onSubmitted: (value) {
                searchContains(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            if (isLoading)
              const LinearProgressIndicator()
            else if (dictionaryModel != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          dictionaryModel!.word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AudioPlayerWidget(
                            audio: dictionaryModel!.phonetics[0].audio),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(dictionaryModel!.phonetics.isNotEmpty
                        ? dictionaryModel!.phonetics[0].text ?? ""
                        : ""),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dictionaryModel!.meanings.length,
                        itemBuilder: (context, index) {
                          return showMeaning(dictionaryModel!.meanings[index]);
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Text(
                  noDataFound,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    String wordDefinition = "";
    for (var element in meaning.definitions) {
      int index = meaning.definitions.indexOf(element);
      wordDefinition += "\n${index + 1}.${element.definition}\n";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.grey[100],
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Text(
              meaning.partOfSpeech,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Definition: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              wordDefinition,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            wordRelation("Synonyms", meaning.synonyms),
            wordRelation("Antonyms", meaning.antonyms),
          ],
        ),
      ),
    );
  }

  wordRelation(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
