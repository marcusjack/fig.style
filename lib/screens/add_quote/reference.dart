import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:memorare/components/circle_button.dart';
import 'package:memorare/components/web/fade_in_x.dart';
import 'package:memorare/components/web/fade_in_y.dart';
import 'package:memorare/data/add_quote_inputs.dart';
import 'package:memorare/state/colors.dart';
import 'package:memorare/utils/language.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddQuoteReference extends StatefulWidget {
  @override
  _AddQuoteReferenceState createState() => _AddQuoteReferenceState();
}

class _AddQuoteReferenceState extends State<AddQuoteReference> {
  final beginY = 100.0;
  final delay = 1.0;
  final delayStep = 1.2;

  String tempImgUrl = '';

  final nameFocusNode = FocusNode();
  final primaryTypeFocusNode = FocusNode();
  final secondaryTypeFocusNode = FocusNode();
  final summaryFocusNode = FocusNode();

  final affiliateUrlController = TextEditingController();
  final amazonUrlController = TextEditingController();
  final facebookUrlController = TextEditingController();
  final nameController = TextEditingController();
  final netflixUrlController = TextEditingController();
  final primaryTypeController = TextEditingController();
  final primeVideoUrlController = TextEditingController();
  final secondaryTypeController = TextEditingController();
  final summaryController = TextEditingController();
  final twitterUrlController = TextEditingController();
  final twitchUrlController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final wikiUrlController = TextEditingController();
  final youtubeUrlController = TextEditingController();

  final linkInputController = TextEditingController();

  @override
  initState() {
    setState(() {
      affiliateUrlController.text = AddQuoteInputs.reference.urls.affiliate;
      amazonUrlController.text = AddQuoteInputs.reference.urls.amazon;
      facebookUrlController.text = AddQuoteInputs.reference.urls.facebook;
      nameController.text = AddQuoteInputs.reference.name;
      netflixUrlController.text = AddQuoteInputs.reference.urls.netflix;
      primeVideoUrlController.text = AddQuoteInputs.reference.urls.primeVideo;
      primaryTypeController.text = AddQuoteInputs.reference.type.primary;
      secondaryTypeController.text = AddQuoteInputs.reference.type.secondary;
      summaryController.text = AddQuoteInputs.reference.summary;
      twitterUrlController.text = AddQuoteInputs.reference.urls.twitter;
      twitchUrlController.text = AddQuoteInputs.reference.urls.twitch;
      websiteUrlController.text = AddQuoteInputs.reference.urls.website;
      wikiUrlController.text = AddQuoteInputs.reference.urls.wikipedia;
      youtubeUrlController.text = AddQuoteInputs.reference.urls.youtube;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600.0,
      child: Column(
        children: <Widget>[
          avatar(),
          nameCardInput(),
          primaryTypeCardInput(),
          secondaryTypeCardInput(),
          clearButton(),
          langSelector(),
          summaryCardInput(),
          FadeInY(
            delay: delay + (5 * delayStep),
            beginY: beginY,
            child: links(),
          ),
        ],
      ),
    );
  }

  Widget clearButton() {
    return FlatButton.icon(
      onPressed: () {
        AddQuoteInputs.clearReference();

        amazonUrlController.clear();
        facebookUrlController.clear();
        nameController.clear();
        netflixUrlController.clear();
        primaryTypeController.clear();
        primeVideoUrlController.clear();
        secondaryTypeController.clear();
        summaryController.clear();
        twitchUrlController.clear();
        twitterUrlController.clear();
        websiteUrlController.clear();
        wikiUrlController.clear();
        youtubeUrlController.clear();

        setState(() {});

        nameFocusNode.requestFocus();
      },
      icon: Opacity(
        opacity: 0.6,
        child: Icon(Icons.clear),
      ),
      label: Opacity(
        opacity: 0.6,
        child: Text(
          'Clear all inputs',
        ),
      ),
    );
  }

  Widget avatar() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Card(
        color: Colors.black12,
        elevation: 0.0,
        child: AddQuoteInputs.reference.urls.image.length > 0
            ? Ink.image(
                width: 150.0,
                height: 200.0,
                fit: BoxFit.cover,
                image: NetworkImage(AddQuoteInputs.reference.urls.image),
                child: InkWell(
                  onTap: () => showAvatarDialog(),
                ),
              )
            : SizedBox(
                width: 150.0,
                height: 200.0,
                child: InkWell(
                  child: Opacity(
                      opacity: .6,
                      child: Icon(
                        Icons.add,
                        size: 50.0,
                        color: stateColors.primary,
                      )),
                  onTap: () => showAvatarDialog(),
                ),
              ),
      ),
    );
  }

  Widget nameCardInput() {
    final referenceName = AddQuoteInputs.reference.name;

    return Container(
      width: 250.0,
      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () async {
            await showCupertinoModalBottomSheet(
                context: context,
                builder: (context, scrollController) {
                  return nameInput();
                });

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      referenceName != null && referenceName.isNotEmpty
                          ? referenceName
                          : 'Tap to edit',
                    ),
                  ],
                ),
              ),
              Icon(Icons.account_box),
            ]),
          ),
        ),
      ),
    );
  }

  Widget nameInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Auto suggestions will show when you'll start typing.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: TextField(
                    autofocus: true,
                    controller: nameController,
                    focusNode: nameFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_outline),
                      labelText: "e.g. 1984, Interstellar",
                      alignLabelWithHint: true,
                    ),
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.reference.name = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.reference.name = '';
                          nameController.clear();
                          nameFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.clear),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Clear input',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryCardInput() {
    final summary = AddQuoteInputs.reference.summary;

    return Container(
      width: 300.0,
      padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () async {
            await showMaterialModalBottomSheet(
                context: context,
                builder: (context, scrollController) {
                  return summaryInput();
                });

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      summary != null && summary.isNotEmpty
                          ? summary
                          : 'Tap to edit',
                    ),
                  ],
                ),
              ),
              Icon(Icons.short_text),
            ]),
          ),
        ),
      ),
    );
  }

  Widget summaryInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Summary",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Write a short summary about this reference. It can be the first Wikipedia paragraph.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: TextField(
                    autofocus: true,
                    controller: summaryController,
                    focusNode: summaryFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit),
                      labelText: "Once upon a time...",
                      alignLabelWithHint: true,
                    ),
                    minLines: 1,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.author.summary = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.author.summary = '';
                          summaryController.clear();
                          summaryFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.clear),
                        ),
                        label: Opacity(
                          opacity: 0.6,
                          child: Text(
                            'Clear input',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.6,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget langSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 60.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Opacity(
            opacity: 0.6,
            child: Text(
              'Reference language: ',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
          ),
          DropdownButton<String>(
            value: AddQuoteInputs.reference.lang,
            iconEnabledColor: stateColors.primary,
            icon: Icon(Icons.language),
            style: TextStyle(
              color: stateColors.primary,
              fontSize: 20.0,
            ),
            onChanged: (newValue) {
              setState(() {
                AddQuoteInputs.reference.lang = newValue;
              });
            },
            items: Language.available().map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget links() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: <Widget>[
          linkSquareButton(
            delay: 1.0,
            name: 'Website',
            active: AddQuoteInputs.reference.urls.website.isNotEmpty,
            imageUrl: 'assets/images/world-globe.png',
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Website',
                  initialValue: AddQuoteInputs.reference.urls.website,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.website = inputUrl;
                    });
                  });
            },
          ),
          Observer(
            builder: (_) {
              return linkSquareButton(
                delay: 1.2,
                name: 'Wikipedia',
                active: AddQuoteInputs.reference.urls.wikipedia.isNotEmpty,
                imageUrl: 'assets/images/wikipedia-${stateColors.iconExt}.png',
                onTap: () {
                  showLinkInputSheet(
                      labelText: 'Wikipedia',
                      initialValue: AddQuoteInputs.reference.urls.wikipedia,
                      onSave: (String inputUrl) {
                        setState(() {
                          AddQuoteInputs.reference.urls.wikipedia = inputUrl;
                        });
                      });
                },
              );
            },
          ),
          linkSquareButton(
            delay: 1.4,
            name: 'Amazon',
            imageUrl: 'assets/images/amazon.png',
            active: AddQuoteInputs.reference.urls.amazon.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Amazon',
                  initialValue: AddQuoteInputs.reference.urls.amazon,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.amazon = inputUrl;
                    });
                  });
            },
          ),
          linkSquareButton(
            delay: 1.6,
            name: 'Facebook',
            imageUrl: 'assets/images/facebook.png',
            active: AddQuoteInputs.reference.urls.facebook.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Facebook',
                  initialValue: AddQuoteInputs.reference.urls.facebook,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.facebook = inputUrl;
                    });
                  });
            },
          ),
          linkSquareButton(
            delay: 1.8,
            name: 'Netflix',
            imageUrl: 'assets/images/netflix.png',
            active: AddQuoteInputs.reference.urls.netflix.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Netflix',
                  initialValue: AddQuoteInputs.reference.urls.netflix,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.netflix = inputUrl;
                    });
                  });
            },
          ),
          linkSquareButton(
            delay: 2.0,
            name: 'Prime Video',
            imageUrl: 'assets/images/prime-video.png',
            active: AddQuoteInputs.reference.urls.primeVideo.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Prime Video',
                  initialValue: AddQuoteInputs.reference.urls.primeVideo,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.primeVideo = inputUrl;
                    });
                  });
            },
          ),
          linkSquareButton(
            delay: 2.2,
            name: 'Twitch',
            imageUrl: 'assets/images/twitch.png',
            active: AddQuoteInputs.reference.urls.twitch.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Twitch',
                  initialValue: AddQuoteInputs.reference.urls.twitch,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.twitch = inputUrl;
                    });
                  });
            },
          ),
          linkSquareButton(
            delay: 2.4,
            name: 'Twitter',
            imageUrl: 'assets/images/twitter.png',
            active: AddQuoteInputs.reference.urls.twitter.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Twitter',
                  initialValue: AddQuoteInputs.reference.urls.twitter,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.twitter = inputUrl;
                    });
                  });
            },
          ),
          linkSquareButton(
            delay: 2.6,
            name: 'YouTube',
            imageUrl: 'assets/images/youtube.png',
            active: AddQuoteInputs.reference.urls.youtube.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'YouTube',
                  initialValue: AddQuoteInputs.reference.urls.youtube,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.reference.urls.youtube = inputUrl;
                    });
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget linkSquareButton({
    bool active = false,
    double delay = 0.0,
    String imageUrl,
    String name,
    Function onTap,
  }) {
    return FadeInX(
      beginX: 50.0,
      delay: delay,
      child: Tooltip(
        message: name,
        child: SizedBox(
          height: 80.0,
          width: 80.0,
          child: Card(
            elevation: active ? 4.0 : 0.0,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  imageUrl,
                  width: 30.0,
                  color: stateColors.foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget primaryTypeCardInput() {
    final primaryType = AddQuoteInputs.reference.type.primary;

    return Container(
      width: 300.0,
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () async {
            await showCupertinoModalBottomSheet(
                context: context,
                builder: (context, scrollController) {
                  return primaryTypeInput();
                });

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Primary type (e.g. TV series)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      primaryType != null && primaryType.isNotEmpty
                          ? primaryType
                          : 'Tap to edit',
                    ),
                  ],
                ),
              ),
              Icon(Icons.filter_1),
            ]),
          ),
        ),
      ),
    );
  }

  Widget primaryTypeInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Primaey type",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "The primary type can be a Book, a Film, a Song for example.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: TextField(
                    autofocus: true,
                    controller: primaryTypeController,
                    focusNode: primaryTypeFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.filter_1),
                      labelText: "e.g. TV series, Book",
                      alignLabelWithHint: true,
                    ),
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.reference.type.primary = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.reference.type.primary = '';
                          primaryTypeController.clear();
                          primaryTypeFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.clear),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Clear input',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget secondaryTypeCardInput() {
    final secondaryType = AddQuoteInputs.reference.type.secondary;

    return Container(
      width: 300.0,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () async {
            await showCupertinoModalBottomSheet(
                context: context,
                builder: (context, scrollController) {
                  return secondaryTypeInput();
                });

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Secondary type (e.g. Thriller)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      secondaryType != null && secondaryType.isNotEmpty
                          ? secondaryType
                          : 'Tap to edit',
                    ),
                  ],
                ),
              ),
              Icon(Icons.filter_2),
            ]),
          ),
        ),
      ),
    );
  }

  Widget secondaryTypeInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Secondary type",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "The secondary type is the sub-category. Thriller, Drama, Fiction, Horror are example.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: TextField(
                    autofocus: true,
                    controller: secondaryTypeController,
                    focusNode: secondaryTypeFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.filter_2),
                      labelText: "e.g. Thriller, Drama",
                      alignLabelWithHint: true,
                    ),
                    minLines: 1,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.reference.type.secondary = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.reference.type.secondary = '';
                          secondaryTypeController.clear();
                          secondaryTypeFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.clear),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Clear input',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showAvatarDialog() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context, scrollController) {
          return Scaffold(
            body: ListView(
              physics: ClampingScrollPhysics(),
              controller: scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SizedBox(
                    width: 250.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleButton(
                              onTap: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                size: 20.0,
                                color: stateColors.primary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        "Reference illustration",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "You can either provide an online link or upload a new picture.",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AddQuoteInputs.author.urls.image.length > 0
                                    ? AddQuoteInputs.author.urls.image
                                    : 'URL',
                          ),
                          onChanged: (newValue) {
                            tempImgUrl = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'CANCEL',
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            AddQuoteInputs.author.urls.image = tempImgUrl;
                          });

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showLinkInputSheet({
    String labelText = '',
    String initialValue = '',
    Function onSave,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String inputUrl;
        linkInputController.text = initialValue;

        return Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 250.0,
                child: TextField(
                  autofocus: true,
                  controller: linkInputController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: labelText,
                    icon: Icon(Icons.link),
                  ),
                  onChanged: (newValue) {
                    inputUrl = newValue;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                  right: 10.0,
                ),
                child: RaisedButton(
                  onPressed: onSave != null
                      ? () {
                          Navigator.pop(context);
                          onSave(inputUrl);
                        }
                      : null,
                  color: stateColors.primary,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          ),
        );
      },
    );
  }
}
