import 'package:flutter/material.dart';
import '../models/task.dart';

/// Simulated "3D" avatar using layered icons that light up based on checked gear.
class AvatarView extends StatelessWidget {
  final List<SafetyGear> gear;
  final Set<String> checked;

  const AvatarView({super.key, required this.gear, required this.checked});

  Color _c(String id) =>
      checked.contains(id) ? const Color(0xFFFFC107) : Colors.white24;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFC107), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body silhouette
          const Icon(Icons.person, size: 220, color: Colors.white30),

          // Helmet (top)
          Positioned(
            top: 10,
            child: Icon(Icons.sports_motorsports,
                size: 56, color: _c('helmet')),
          ),

          // Goggles (near face)
          if (gear.any((g) => g.id == 'goggles'))
            Positioned(
              top: 70,
              child: Icon(Icons.visibility, size: 32, color: _c('goggles')),
            ),

          // Harness (chest)
          if (gear.any((g) => g.id == 'harness'))
            Positioned(
              top: 110,
              child: Icon(Icons.airline_seat_legroom_extra,
                  size: 44, color: _c('harness')),
            ),

          // Gloves (hands)
          if (gear.any((g) => g.id == 'gloves'))
            Positioned(
              left: 30,
              top: 130,
              child: Icon(Icons.back_hand, size: 36, color: _c('gloves')),
            ),
          if (gear.any((g) => g.id == 'gloves'))
            Positioned(
              right: 30,
              top: 130,
              child: Icon(Icons.back_hand, size: 36, color: _c('gloves')),
            ),

          // Boots (feet)
          if (gear.any((g) => g.id == 'boots'))
            Positioned(
              bottom: 10,
              child: Icon(Icons.hiking, size: 44, color: _c('boots')),
            ),
        ],
      ),
    );
  }
}
