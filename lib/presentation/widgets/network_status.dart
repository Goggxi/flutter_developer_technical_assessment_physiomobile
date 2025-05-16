import 'package:flutter/material.dart';
import 'package:physiomobile_technical_assessment/core/theme/app_colors.dart';
import 'package:physiomobile_technical_assessment/core/utils/extensions/context_extension.dart';

class NetworkStatus extends StatelessWidget {
  final bool isConnected;
  const NetworkStatus({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isConnected ? AppColors.darkPrimary : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isConnected ? "Network Available" : "No Network Connection",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.themeExt.textTheme.titleSmall?.copyWith(
              color:
                  isConnected ? AppColors.solidDarkBlue : Colors.red.shade900,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color:
                  isConnected ? Colors.lightGreenAccent : Colors.red.shade300,
              border: Border.all(
                color: isConnected ? Colors.lightGreen : Colors.red.shade400,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}
