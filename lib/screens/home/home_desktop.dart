import 'package:flutter/material.dart';
import 'package:memorare/components/web/discover_references.dart';
import 'package:memorare/components/web/discover_authors.dart';
import 'package:memorare/components/web/footer.dart';
import 'package:memorare/components/web/full_page_quotidian.dart';
import 'package:memorare/components/web/home_app_bar.dart';
import 'package:memorare/components/web/topics.dart';
import 'package:supercharged/supercharged.dart';

class HomeDesktop extends StatefulWidget {
  @override
  _HomeDesktopState createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          HomeAppBar(
            onTapIconHeader: () {
              scrollController.animateTo(
                0,
                duration: 250.milliseconds,
                curve: Curves.decelerate,
              );
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              FullPageQuotidian(),
              Topics(),
              DiscoverReferences(),
              DiscoverAuthors(),
              Footer(
                pageScrollController: scrollController,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}