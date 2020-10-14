import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:memorare/components/simple_appbar.dart';
import 'package:memorare/components/web/app_icon_header.dart';
import 'package:memorare/components/web/fade_in_y.dart';
import 'package:memorare/data/add_quote_inputs.dart';
import 'package:memorare/screens/settings.dart';
import 'package:memorare/screens/add_quote/steps.dart';
import 'package:memorare/screens/recent_quotes.dart';
import 'package:memorare/screens/admin_temp_quotes.dart';
import 'package:memorare/screens/drafts.dart';
import 'package:memorare/screens/published_quotes.dart';
import 'package:memorare/screens/quotes_lists.dart';
import 'package:memorare/screens/quotidians.dart';
import 'package:memorare/screens/signin.dart';
import 'package:memorare/screens/signup.dart';
import 'package:memorare/screens/temp_quotes.dart';
import 'package:memorare/screens/web/favourites.dart';
import 'package:memorare/state/colors.dart';
import 'package:memorare/state/user_state.dart';
import 'package:memorare/utils/app_localstorage.dart';
import 'package:memorare/utils/snack.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:supercharged/supercharged.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool canManage = false;
  bool prevIsAuthenticated = false;
  bool isAccountAdvVisible = false;

  double beginY = 20.0;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add quote"),
        icon: Icon(Icons.add),
        onPressed: () {
          AddQuoteInputs.clearAll();
          AddQuoteInputs.navigatedFromPath = 'dashboard';
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddQuoteSteps()));
        },
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          appBar(),
          body(),
        ],
      ),
    );
  }

  List<Widget> adminWidgets(BuildContext context) {
    return [
      ControlledAnimation(
        duration: 250.milliseconds,
        tween: Tween(begin: 0.0, end: MediaQuery.of(context).size.width),
        builder: (_, value) {
          return SizedBox(
            width: value,
            child: Divider(
              thickness: 1.0,
              height: 30.0,
            ),
          );
        },
      ),
      FadeInY(
        delay: 0.9,
        beginY: beginY,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 50.0),
          leading: Icon(Icons.question_answer, size: 30.0),
          title: Text(
            'All published',
            style: TextStyle(fontSize: 20.0),
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RecentQuotes())),
        ),
      ),
      FadeInY(
        delay: 1.0,
        beginY: beginY,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 50.0),
          leading: Icon(Icons.timelapse, size: 30.0),
          title: Text(
            'All in validation',
            style: TextStyle(fontSize: 20.0),
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AdminTempQuotes())),
        ),
      ),
      FadeInY(
        delay: 1.1,
        beginY: beginY,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 50.0),
          leading: Icon(Icons.wb_sunny, size: 30.0),
          title: Text(
            'Quotidians',
            style: TextStyle(fontSize: 20.0),
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => Quotidians())),
        ),
      ),
    ];
  }

  Widget appBar() {
    return SimpleAppBar(
      expandedHeight: 120.0,
      title: TextButton.icon(
        onPressed: () {
          scrollController.animateTo(
            0,
            duration: 250.milliseconds,
            curve: Curves.easeIn,
          );
        },
        icon: AppIconHeader(
          padding: EdgeInsets.zero,
          size: 30.0,
        ),
        label: Text(
          'Account',
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
      ),
      showNavBackIcon: false,
    );
  }

  List<Widget> authWidgets(BuildContext context) {
    return [
      Column(
        children: <Widget>[
          FadeInY(
            delay: 0.1,
            beginY: beginY,
            child: draftsButton(),
          ),
          FadeInY(
            delay: 0.2,
            beginY: beginY,
            child: listsButton(),
          ),
          FadeInY(
            delay: 0.3,
            beginY: beginY,
            child: tempQuotesButton(),
          ),
          FadeInY(
            delay: 0.4,
            beginY: beginY,
            child: favButton(),
          ),
          FadeInY(
            delay: 0.5,
            beginY: beginY,
            child: pubQuotesButton(),
          ),
          FadeInY(
            delay: 0.6,
            beginY: beginY,
            child: settingsButton(),
          ),
          FadeInY(delay: 0.7, beginY: beginY, child: helpCenterButton()),
          FadeInY(delay: 0.8, beginY: beginY, child: signOutButton()),
        ],
      ),
    ];
  }

  Widget body() {
    return Observer(builder: (context) {
      List<Widget> children = [];

      final isConnected = userState.isUserConnected;

      if (isConnected) {
        // children.add(avatarContainer());
        children.addAll(authWidgets(context));

        if (canManage) {
          children.addAll(adminWidgets(context));
        }
      } else {
        children.add(whyAccountBlock());
        children.addAll(guestWidgets(context));
      }

      return SliverPadding(
        padding: const EdgeInsets.only(
          bottom: 150.0,
        ),
        sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          ]),
        ),
      );
    });
  }

  Widget bulletPoint({String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
          ),
          Expanded(
            child: Opacity(
              opacity: 0.6,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget connectionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60.0,
      ),
      child: Column(
        children: [
          signinButton(),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
          ),
          signupButton(),
        ],
      ),
    );
  }

  Widget draftsButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.edit,
        size: 30.0,
      ),
      title: Text(
        'Drafts',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Drafts())),
    );
  }

  Widget favButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.favorite,
        size: 30.0,
      ),
      title: Text(
        'Favourites',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Favourites())),
    );
  }

  List<Widget> guestWidgets(BuildContext context) {
    return [
      FadeInY(
        delay: 0.2,
        beginY: beginY,
        child: connectionButtons(),
      ),
      Divider(
        height: 100.0,
        thickness: 1.0,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInY(
            delay: 0.3,
            beginY: beginY,
            child: settingsButton(),
          ),
          FadeInY(
            delay: 0.4,
            beginY: beginY,
            child: helpCenterButton(),
          ),
        ],
      ),
    ];
  }

  Widget helpCenterButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.help_outline,
        size: 30.0,
      ),
      title: Text(
        'Help Center',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => launch('https://help.outofcontext.app'),
    );
  }

  Widget signOutButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.exit_to_app,
        size: 30.0,
      ),
      title: Text(
        'Sign out',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () async {
        await appLocalStorage.clearUserAuthData();
        await FirebaseAuth.instance.signOut();
        userState.signOut();

        setState(() {
          canManage = false;
        });

        showSnack(
          context: context,
          message: 'You have been successfully disconnected.',
          type: SnackType.success,
        );
      },
    );
  }

  Widget listsButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.list,
        size: 30.0,
      ),
      title: Text(
        'Lists',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => QuotesLists())),
    );
  }

  Widget pubQuotesButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.check,
        size: 30.0,
      ),
      title: Text(
        'Published',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MyPublishedQuotes())),
    );
  }

  Widget settingsButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.settings,
        size: 30.0,
      ),
      title: Text(
        'Settings',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Settings())),
    );
  }

  Widget signinButton() {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Signin()));
      },
      textColor: stateColors.primary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
          side: BorderSide(
            color: stateColors.primary,
          )),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 220.0,
          minHeight: 60.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SIGN IN',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signupButton() {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Signup()));
      },
      textColor: Colors.orange.shade600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
          side: BorderSide(
            color: Colors.orange.shade600,
          )),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 220.0,
          minHeight: 60.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(Icons.person_add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tempQuotesButton() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50.0),
      leading: Icon(
        Icons.timelapse,
        size: 30.0,
      ),
      title: Text(
        'In validation',
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MyTempQuotes())),
    );
  }

  Widget whyAccountBlock() {
    return FadeInY(
      beginY: beginY,
      delay: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 50.0,
          bottom: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton(
              onPressed: () =>
                  setState(() => isAccountAdvVisible = !isAccountAdvVisible),
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  'WHY AN ACCOUNT?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (isAccountAdvVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 10.0)),
                  bulletPoint(text: 'Favourites quotes'),
                  bulletPoint(text: 'Create thematic lists'),
                  bulletPoint(text: 'Propose new quotes'),
                  bulletPoint(text: '& more...'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future fetchUserData() async {
    try {
      final userAuth = await userState.userAuth;

      if (userAuth == null) {
        return;
      }

      final user = await Firestore.instance
          .collection('users')
          .document(userAuth.uid)
          .get();

      final data = user.data;

      setState(() {
        canManage = data['rights']['user:managequote'] ?? false;
      });
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
