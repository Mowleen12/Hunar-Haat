import 'package:flutter/material.dart';
import 'my_orders_screen.dart';
import 'my_address_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';
import 'profile_builder_screen.dart'; // New: Import the profile builder screen
import 'product_cataloging_screen.dart'; // New: Import the product cataloging screen

// Colors
const Color kIndianRed = Color(0xFFB22222);
const Color kGold = Color(0xFFD4AF37);
const Color kCharcoal = Color(0xFF36454F);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kWhiteColor = Colors.white;

class AccountScreen extends StatelessWidget {
const AccountScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
	  appBar: AppBar(
		title: const Text(
		  "My Account",
		  style: TextStyle(fontWeight: FontWeight.bold),
		),
		backgroundColor: kIndianRed,
		foregroundColor: kWhiteColor,
	  ),
	  body: ListView(
		children: [
		  // Profile Section
		  Container(
			color: kLightGrey,
			padding: const EdgeInsets.all(16),
			child: Row(
			  children: [
				const CircleAvatar(
				  radius: 35,
				  backgroundColor: kIndianRed,
				  child: Icon(Icons.person, color: kWhiteColor, size: 40),
				),
				const SizedBox(width: 16),
				Column(
				  crossAxisAlignment: CrossAxisAlignment.start,
				  children: const [
					Text(
					  "Mowleen Armstrong",
					  style: TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
					  ),
					),
					Text(
					  "mowleen2006@gmail.com",
					  style: TextStyle(color: Colors.black54),
					),
				  ],
				)
			  ],
			),
		  ),

		  const SizedBox(height: 10),

// Options List
  Card(
	margin: const EdgeInsets.all(12),
	shape:
		RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
	child: Column(
	  children: [
		// New: AI Profile Builder Option
		_buildAccountOption(
		  icon: Icons.auto_awesome,
		  title: "AI Profile Builder",
		  onTap: () {
			Navigator.push(
			  context,
			  MaterialPageRoute(
				builder: (context) => const ProfileBuilderScreen(),
			  ),
			);
		  },
		),
		// New: Smart Product Cataloging Option
		_buildAccountOption(
		  icon: Icons.image_search,
		  title: "Smart Product Cataloging",
		  onTap: () {
			Navigator.push(
			  context,
			  MaterialPageRoute(
				builder: (context) => const ProductCatalogingScreen(),
			  ),
			);
		  },
		),
		_buildAccountOption(
		  icon: Icons.shopping_bag_outlined,
		  title: "My Orders",
		  onTap: () {
			Navigator.push(
			  context,
			  MaterialPageRoute(
				builder: (context) => const MyOrdersScreen(),
			  ),
			);
		  },
		),
		_buildAccountOption(
		  icon: Icons.location_on_outlined,
		  title: "My Addresses",
		  onTap: () {
			Navigator.push(
			  context,
			  MaterialPageRoute(
				builder: (context) => const MyAddressScreen(),
			  ),
			);
		  },
		),
		_buildAccountOption(
		  icon: Icons.help_outline,
		  title: "Help & Support",
		  onTap: () {
			Navigator.push(
			  context,
			  MaterialPageRoute(
				builder: (context) => const HelpSupportScreen(),
			  ),
			);
		  },
		),
		_buildAccountOption(
		  icon: Icons.logout,
		  title: "Logout",
		  onTap: () {
			_showLogoutDialog(context);
		  },
		),
	  ],
	),
  ),
		],
	  ),
	);
  }
// Reusable ListTile Widget
static Widget _buildAccountOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
	leading: Icon(icon, color: kIndianRed),
	title: Text(title, style: const TextStyle(fontSize: 16)),
	trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: kCharcoal),
	onTap: onTap,
  );
}

// Logout confirmation dialog
static void _showLogoutDialog(BuildContext context) {
  showDialog(
	context: context,
	builder: (context) => AlertDialog(
	  shape: RoundedRectangleBorder(
		borderRadius: BorderRadius.circular(12),
	  ),
	  title: const Text(
		"Logout",
		style: TextStyle(fontWeight: FontWeight.bold),
	  ),
	  content: const Text("Are you sure you want to log out?"),
	  actions: [
		TextButton(
		  onPressed: () => Navigator.pop(context),
		  child: const Text(
			"Cancel",
			style: TextStyle(color: Colors.black),
		  ),
		),
		ElevatedButton(
		  style: ElevatedButton.styleFrom(
			backgroundColor: kIndianRed,
			foregroundColor: Colors.white,
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(8),
			),
		  ),
		  onPressed: () {
			Navigator.pop(context);
			Navigator.pushReplacement(
			  context,
			  MaterialPageRoute(builder: (context) => const LoginScreen()),
			);
		  },
		  child: const Text(
			"Logout",
			style: TextStyle(fontWeight: FontWeight.bold),
		  ),
		),
	  ],
	),
  );
}
} //can you implement the second feature now?
//please add in this