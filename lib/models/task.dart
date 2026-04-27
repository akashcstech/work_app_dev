import 'package:flutter/material.dart';

class SafetyTask {
  final String id;
  final String name;
  final IconData icon;
  final List<SafetyGear> gear;
  final String likelyInjury;

  const SafetyTask({
    required this.id,
    required this.name,
    required this.icon,
    required this.gear,
    required this.likelyInjury,
  });
}

class SafetyGear {
  final String id;
  final String name;
  final IconData icon;

  const SafetyGear({required this.id, required this.name, required this.icon});
}

// Predefined gear
const helmet = SafetyGear(id: 'helmet', name: 'Helmet', icon: Icons.sports_motorsports);
const gloves = SafetyGear(id: 'gloves', name: 'Gloves', icon: Icons.back_hand);
const goggles = SafetyGear(id: 'goggles', name: 'Goggles', icon: Icons.visibility);
const boots = SafetyGear(id: 'boots', name: 'Safety Boots', icon: Icons.hiking);
const harness = SafetyGear(id: 'harness', name: 'Harness', icon: Icons.airline_seat_legroom_extra);

const kTasks = <SafetyTask>[
  SafetyTask(
    id: 'welding',
    name: 'Welding',
    icon: Icons.local_fire_department,
    gear: [helmet, gloves, goggles],
    likelyInjury: 'Burns, eye damage, toxic fume inhalation',
  ),
  SafetyTask(
    id: 'height',
    name: 'Height Work',
    icon: Icons.stairs,
    gear: [helmet, harness, boots],
    likelyInjury: 'Falls from height — fractures or fatal injury',
  ),
  SafetyTask(
    id: 'digging',
    name: 'Digging Trench',
    icon: Icons.construction,
    gear: [helmet, gloves, boots],
    likelyInjury: 'Cave-in injury, foot crush, hand lacerations',
  ),
];
