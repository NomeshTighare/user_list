import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:user_list/models/user.dart';
import 'package:user_list/userProfile.dart';

class UserList extends StatefulWidget {
  const UserList({super.key, required this.title});

  final String title;
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int pageCount = 0;
  String searchValue = '';
  bool _isFirstLoadRunning = true;
  bool _isLoadMoreRunning = false;
  List<User> userList = <User>[];

  ScrollController _scrollController = ScrollController();

  TextEditingController _searchController = TextEditingController();

  Future<List<User>?> getAllUserFirstTime() async {
    setState(() {
      _isFirstLoadRunning = true;
      userList = [];
    });

    // print('Page: $pageCount');
    var result;
    result = await User().getAllUser(
      page: pageCount,
      query: searchValue,
    );

    userList.addAll(result['data']);

    setState(() {
      _isFirstLoadRunning = false;
    });
    print('Total user: ${userList.length}');
    print(userList[0].firstName);
    return userList;
  }

  Future<List<User>?> getNextUser() async {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    });

    print('Page: $pageCount');
    var result;

    result = await User().getAllUser(page: pageCount, query: searchValue);
    print(result);
    if (result['status']) {
      userList.addAll(result['data']);
    }
    setState(() {
      _isLoadMoreRunning = false;
    });
    print('Total user: ${userList.length}');
    return userList;
  }

  @override
  void initState() {
    super.initState();
    getAllUserFirstTime();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $_isLoadMoreRunning");
        pageCount = pageCount + 1;

        getNextUser();
      });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to top $_isLoadMoreRunning");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Users List',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Text('All Teams Members'),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    searchValue = value;
                    pageCount = 0;
                    getAllUserFirstTime();
                  });
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      setState(() {
                        pageCount = 0;
                        getAllUserFirstTime();
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: _isFirstLoadRunning
                    ? Center(child: CupertinoActivityIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                          itemCount: userList?.length,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true, // add this otherwise an error
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => UserProfile())));
                              },
                              child: Row(
                                children: [
                                  Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(
                                            userList[index].picture ??
                                                'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                                          ).image,
                                        ),
                                      )),
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 5),
                                    width: 300,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${userList[index].firstName} ${userList[index].firstName}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                        Text(
                                          '${userList[index].email ?? ''}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
              if (_isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: Center(child: CupertinoActivityIndicator()),
                )
            ],
          ),
        ),
      ),
    );
  }
}
