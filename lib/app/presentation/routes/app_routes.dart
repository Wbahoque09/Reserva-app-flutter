import '../modules/detailsloans/view/detailsloans_view.dart';
import '../modules/detailsreserve/view/detailsreserve_view.dart';
import '../modules/onbording/view/onbording_view.dart';
import 'package:flutter/widgets.dart' show BuildContext, Widget;

import '../modules/details/view/details_view.dart';
import '../modules/home/view/home_view.dart';
import '../modules/login/view/login_view.dart';
import '../modules/register/view/register_view.dart';
import '../modules/student/view/student_view.dart';
import '../modules/teacher/view/teacher_view.dart';
import 'routes.dart';

/// WARNING: generated code don't modify directly
Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.HOME: (_) => const HomeView(),
    Routes.REGISTER: (_) => const RegisterView(),
    Routes.LOGIN: (_) => const LoginView(),
    Routes.TEACHER: (_) => const TeacherView(),
    Routes.STUDENT: (_) => const StudentView(),
    Routes.DETAILS: (_) => const DetailsView(),
  
    Routes.ONBORDING: (_) => const OnbordingView(),

    Routes.DETAILSRESERVE: (_) => const DetailsreserveView(),

    Routes.DETAILSLOANS: (_) => const DetailsloansView(),
};
}

        
        
        