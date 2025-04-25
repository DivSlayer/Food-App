class NavModel {
  final String title, icon;
  final bool hasNotif;
  final int notifCount;

  NavModel({
    required this.title,
    required this.icon,
    this.hasNotif = false,
    this.notifCount=0,
  });
}
