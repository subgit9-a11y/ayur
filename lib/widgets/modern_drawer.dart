import 'package:flutter/material.dart';
import 'package:doctro/constant/app_icons.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/screens/auth/professional_registration_screen.dart';
import 'package:doctro/core/theme/glass_theme.dart';
import 'package:doctro/shared/glass_card.dart';

class ModernDrawer extends StatelessWidget {
  const ModernDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? dName = SharedPreferenceHelper.getString(Preferences.name);
    final String? dFullImage =
        SharedPreferenceHelper.getString(Preferences.image);
    final String? phone =
        SharedPreferenceHelper.getString(Preferences.phone_no);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GlassTheme.bgLight,
              GlassTheme.lightGreen.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 54, left: 22, right: 22, bottom: 22),
              decoration: BoxDecoration(
                color: GlassTheme.primaryGreen.withOpacity(0.1),
                border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: GlassTheme.primaryGreen.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.16)),
                    ),
                    child: Text(
                      "Ayureze Doctor Desk",
                      style: TextStyle(
                        color: GlassTheme.primaryGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: GlassTheme.accentTeal, width: 2),
                      image: DecorationImage(
                        image: (dFullImage != null && dFullImage!.isNotEmpty)
                            ? NetworkImage(dFullImage!)
                            : const AssetImage("assets/images/no_image.jpg")
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Dr. ${dName ?? "Doctor"}",
                    style: TextStyle(
                        color: GlassTheme.textPrimaryLight,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    phone ?? "",
                    style: TextStyle(
                        color: GlassTheme.textSecondaryLight, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: GlassTheme.primaryGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      "Verified Professional",
                      style: TextStyle(
                        color: GlassTheme.primaryGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
                children: [
                  _buildSectionHeader("Main"),
                  _drawerItem(
                      context,
                      AppIcons.home,
                      getTranslated(context, AppString.drawer_home).toString(),
                      () => Navigator.popUntil(
                          context, ModalRoute.withName('loginHome'))),
                  _drawerItem(
                      context,
                      AppIcons.notifications,
                      getTranslated(context, AppString.drawer_notification)
                          .toString(),
                      () =>
                          Navigator.popAndPushNamed(context, 'notifications')),
                  const SizedBox(height: 10),
                  _buildSectionHeader("Appointments"),
                  _drawerItem(
                      context,
                      AppIcons.appointment,
                      getTranslated(context, AppString.drawer_appointments)
                          .toString(),
                      () => Navigator.popAndPushNamed(
                          context, 'AppointmentHistoryScreen')),
                  _drawerItem(
                      context,
                      AppIcons.clock,
                      getTranslated(context, AppString.drawer_schedule_timing)
                          .toString(),
                      () => Navigator.popAndPushNamed(
                          context, 'Schedule Timings')),
                  _drawerItem(
                      context,
                      AppIcons.close,
                      getTranslated(
                              context, AppString.drawer_canceled_appointment)
                          .toString(),
                      () => Navigator.popAndPushNamed(
                          context, 'cancelAppoitmentRoutes')),
                  const SizedBox(height: 10),
                  _buildSectionHeader("Management"),
                  _drawerItem(
                      context,
                      AppIcons.star,
                      getTranslated(context, AppString.drawer_review)
                          .toString(),
                      () => Navigator.popAndPushNamed(
                          context, 'rateAndReviewRoutes')),
                  _drawerItem(
                      context, AppIcons.verified, "Profile & Registration", () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfessionalRegistrationScreen()));
                  }),
                  _drawerItem(
                      context,
                      AppIcons.settings,
                      getTranslated(context, AppString.drawer_setting)
                          .toString(),
                      () => Navigator.popAndPushNamed(context, 'Settings')),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Divider(
                        color: GlassTheme.textSecondaryLight.withOpacity(0.2)),
                  ),
                  _drawerItem(
                      context,
                      Icons.logout,
                      getTranslated(context, AppString.drawer_logout)
                          .toString(),
                      () => _showLogoutDialog(context),
                      isDestructive: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: GlassTheme.textSecondaryLight.withOpacity(0.8),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red.withOpacity(0.1)
                  : GlassTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon,
                color: isDestructive ? Colors.red : GlassTheme.primaryGreen,
                size: 20),
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isDestructive ? Colors.red : GlassTheme.textPrimaryLight,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isDestructive
                ? Colors.red.withOpacity(0.7)
                : GlassTheme.textSecondaryLight,
          ),
          onTap: onTap,
          dense: true,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated(context, AppString.drawer_logout).toString()),
        content: Text(
            getTranslated(context, AppString.are_you_sure_logout).toString()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                  getTranslated(context, AppString.cancel_button).toString())),
          TextButton(
            onPressed: () {
              SharedPreferenceHelper.clearPref();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'SignIn', (route) => false);
            },
            child: Text(
                getTranslated(context, AppString.logout_button).toString(),
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
