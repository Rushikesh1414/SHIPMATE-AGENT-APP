import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';

class ProgressTracker extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> labels;

  const ProgressTracker({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.labels,
  })  : assert(labels.length == totalSteps),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              Row(
                children: List.generate(totalSteps * 2 - 1, (index) {
                  if (index.isEven) {
                    int stepIndex = index ~/ 2;
                    bool isActive = stepIndex == currentStep;
                    bool isCompleted = stepIndex < currentStep;

                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted || isActive ? AppColors.primaryColor : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : Text(
                                '${stepIndex + 1}',
                                style: GoogleFonts.inter(
                                  color: isActive ? Colors.white : Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  } else {
                    // Connector line
                    int lineIndex = (index - 1) ~/ 2;
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: lineIndex < currentStep ? AppColors.primaryColor : Colors.grey[300],
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(totalSteps, (i) {
                return Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: i <= currentStep ? AppColors.primaryColor : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
