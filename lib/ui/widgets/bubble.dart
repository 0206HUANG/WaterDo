import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../screens/task_detail_screen.dart';

class Bubble extends StatefulWidget {
  final Task task;
  const Bubble(this.task, {super.key});

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  // Track if we've already triggered the task completion
  bool _hasCompletedTask = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pop() async {
    // Prevent double-completion
    if (_hasCompletedTask || widget.task.done) {
      return;
    }

    // Add a listener for the animation status
    void handleAnimationStatusChange(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        // Only toggle the task when animation is completely done
        // and ensure we only do it once
        if (mounted && !_hasCompletedTask) {
          _hasCompletedTask = true;
          // Use a slight delay to prevent UI issues
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              final provider = Provider.of<TaskProvider>(
                context,
                listen: false,
              );
              provider.toggle(widget.task);
            }
          });
        }
        // Remove the listener to avoid memory leaks
        _controller.removeStatusListener(handleAnimationStatusChange);
      }
    }

    // Add the status listener
    _controller.addStatusListener(handleAnimationStatusChange);

    // Start the animation
    await _controller.forward();
  }

  void _showDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: widget.task),
      ),
    );
  }

  @override
  void didUpdateWidget(Bubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset completion flag if the task changes
    if (oldWidget.task.id != widget.task.id) {
      _hasCompletedTask = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final float =
        sin(
          DateTime.now().millisecondsSinceEpoch / 1000 + Random().nextDouble(),
        ) *
        4;

    return Transform.translate(
      offset: Offset(0, float),
      child: GestureDetector(
        onTap: _showDetails,
        onDoubleTap: _pop,
        child: ScaleTransition(
          scale: Tween(
            begin: 1.0,
            end: 0.0,
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn)),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: widget.task.done ? Colors.grey : Colors.indigo.shade400,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.task.done ? Colors.grey : Colors.indigo,
                  blurRadius: 6,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.task.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration:
                          widget.task.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.task.schedule == null
                        ? 'Today'
                        : '${widget.task.schedule!.year}/${widget.task.schedule!.month}/${widget.task.schedule!.day}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
