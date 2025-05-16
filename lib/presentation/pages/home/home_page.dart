import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:physiomobile_technical_assessment/core/constants/asset_constants.dart';
import 'package:physiomobile_technical_assessment/core/theme/app_colors.dart';
import 'package:physiomobile_technical_assessment/core/utils/network/network_info.dart';
import 'package:physiomobile_technical_assessment/di.dart';
import 'package:physiomobile_technical_assessment/presentation/pages/home/set_state_counter_fragment.dart';
import 'package:physiomobile_technical_assessment/presentation/pages/post_page.dart';
import 'package:physiomobile_technical_assessment/presentation/pages/simple_form_page.dart';
import 'package:physiomobile_technical_assessment/presentation/widgets/network_status.dart';
import 'package:physiomobile_technical_assessment/core/utils/extensions/context_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NetworkInfo _networkInfo = sl();
  late StreamSubscription<bool> _connectivitySubscription;
  bool _isConnected = true;
  double _topSheetHeight = 0.0;
  double _bottomSheetHeight = 0.0;
  bool _isBottomSheetExpanded = false;
  bool _isShowing = false;

  Future<void> _initConnectivity() async {
    try {
      _isConnected = await _networkInfo.isConnected;
      setState(() {});
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }
  }

  void _listenConnectivity() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen((
      connected,
    ) {
      setState(() {
        _isConnected = connected;
      });
    });
  }

  void _toggleBottomSheet() {
    final size = context.sizeExt;
    HapticFeedback.lightImpact();
    setState(() {
      _isBottomSheetExpanded = !_isBottomSheetExpanded;
      _bottomSheetHeight =
          _isBottomSheetExpanded ? size.height * 0.8 : size.height * 0.4;
      _topSheetHeight = _isBottomSheetExpanded ? size.height * 0.2 : 0.0;
    });
  }

  void _navigateToPostPage() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostPage()),
    );
  }

  void _navigateToSimpleFormPage() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SimpleFormPage()),
    );
  }

  @override
  void initState() {
    _initConnectivity();
    _listenConnectivity();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _bottomSheetHeight = context.sizeExt.height * 0.4;
        _isShowing = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          _buildGradientBackground(context),
          _buildIllustrationBackground(context),
          _buildBody(context),
          _buildTopSheet(context),
          _buildBottomSheet(context),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Image.asset(
      AssetConstants.scaffoldBg,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.solidPurple.withAlpha(100),
            AppColors.solidDarkBlue.withAlpha(50),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 0.5],
        ),
      ),
    );
  }

  Widget _buildIllustrationBackground(BuildContext context) {
    final size = context.sizeExt;
    return Center(
      child: Image.asset(
        AssetConstants.house,
        fit: BoxFit.cover,
        width: size.width * 0.8,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = context.sizeExt;
    final padding = context.paddingExt;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: padding.top * 2.4,
        left: 20,
        right: 20,
        bottom: padding.bottom + 20,
      ),
      child: Column(
        children: [
          SizedBox(width: size.width),
          NetworkStatus(isConnected: _isConnected),
        ],
      ),
    );
  }

  Widget _buildTopSheet(BuildContext context) {
    final size = context.sizeExt;
    final padding = context.paddingExt;
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            height: _topSheetHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.solidPurple, AppColors.solidDarkBlue],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: size.width, height: padding.top * 2.4),
                  NetworkStatus(isConnected: _isConnected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            height: _bottomSheetHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_isBottomSheetExpanded ? 0 : 44),
                topRight: Radius.circular(_isBottomSheetExpanded ? 0 : 44),
              ),
              image: DecorationImage(
                image: AssetImage(AssetConstants.line),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.solidDarkBlue.withAlpha(
                    _isBottomSheetExpanded ? 255 : 120,
                  ),
                  AppColors.solidPurple.withAlpha(
                    _isBottomSheetExpanded ? 255 : 120,
                  ),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child:
                _isShowing
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Counter App',
                          style: TextStyle(
                            color: AppColors.solidLightPurple,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Flexible(child: SetStateCounterFragment()),
                      ],
                    )
                    : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final size = context.sizeExt;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: 0,
          child: Image.asset(
            AssetConstants.bottomBarBack,
            width: size.width,
            height: size.height * 0.10,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Image.asset(
            AssetConstants.bottomBarFront,
            width: size.width * 0.7,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          bottom: 16,
          child: SizedBox(
            width: size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _navigateToSimpleFormPage,
                  icon: SvgPicture.asset(
                    AssetConstants.map,
                    height: 46,
                    width: 46,
                  ),
                ),
                SizedBox(width: size.width * 0.55),
                IconButton(
                  onPressed: _navigateToPostPage,
                  icon: SvgPicture.asset(
                    AssetConstants.list,
                    height: 46,
                    width: 46,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 23,
          child: SizedBox(
            width: size.width * 0.18,
            height: size.width * 0.18,
            child: CircularProgressIndicator(
              value: _isBottomSheetExpanded ? 1 : 0.0,
              backgroundColor: AppColors.solidLightPurple,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.solidPink.withAlpha(100),
              ),
              strokeWidth: 2,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          child: IconButton(
            onPressed: _toggleBottomSheet,
            icon: Image.asset(
              !_isBottomSheetExpanded
                  ? AssetConstants.addSecondary
                  : AssetConstants.addPrimary,
              fit: BoxFit.contain,
              width: size.width * 0.18,
            ),
          ),
        ),
      ],
    );
  }
}
