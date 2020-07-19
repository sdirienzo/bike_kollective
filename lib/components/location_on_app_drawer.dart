import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/authentication_manager.dart';
import '../components/size_calculator.dart';
import '../app/app_styles.dart';
import '../app/app_strings.dart';

class LocationOnAppDrawer extends StatelessWidget {
  LocationOnAppDrawer({Key key, this.userEmail}) : super(key: key);

  static const appLogoPath = 'lib/assets/images/app_logo.png';
  final AuthenticationManager _auth = AuthenticationManager();
  final userEmail;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _header(context),
          _bikesTile(context),
          _addBikeTile(context),
          _logoutTile(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return DrawerHeader(
      child: Row(
        children: <Widget>[
          _appLogo(context),
          _email(),
        ],
      ),
    );
  }

  Widget _appLogo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppStyles.appLogoThumbnailPadding),
      child: Image(
        image: AssetImage(appLogoPath),
        height: sizeCalculator(context, AppStyles.appLogoThumbnailHeight),
      ),
    );
  }

  Widget _email() {
    return Text(userEmail);
  }

  Widget _bikesTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.directions_bike,
        color: AppStyles.appDrawerIconColor,
      ),
      title: Text('${AppStrings.appDrawerBikesLabel}'),
      onTap: () {
        _pushBikeList(context);
      },
    );
  }

  Widget _addBikeTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.add,
        color: AppStyles.appDrawerIconColor,
      ),
      title: Text('${AppStrings.appDrawerAddBikeLabel}'),
      onTap: () {
        _pushAddBike(context);
      },
    );
  }

  Widget _logoutTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        color: AppStyles.appDrawerIconColor,
      ),
      title: Text('${AppStrings.appDrawerLogoutLabel}'),
      onTap: () {
        _logout();
        _pushLogin(context);
      },
    );
  }

  Future<void> _logout() async {
    return await _auth.signOut();
  }

  // Need to update once bike list screen is complete
  void _pushBikeList(BuildContext context) {
    Navigator.pushNamed(context, '/list');
  }

  void _pushAddBike(BuildContext context) {
    Navigator.pushNamed(context, '/add');
  }

  void _pushLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }
}
