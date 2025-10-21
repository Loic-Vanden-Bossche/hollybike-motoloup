// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i23;

import 'package:auto_route/auto_route.dart' as _i15;
import 'package:collection/collection.dart' as _i21;
import 'package:flutter/foundation.dart' as _i24;
import 'package:flutter/material.dart' as _i16;
import 'package:hollybike/auth/screens/login_screen.dart' as _i9;
import 'package:hollybike/auth/screens/signup_screen.dart' as _i13;
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart'
    as _i20;
import 'package:hollybike/event/screens/event_details_screen.dart' as _i3;
import 'package:hollybike/event/screens/events_screen.dart' as _i5;
import 'package:hollybike/event/screens/participations/event_candidates_screen.dart'
    as _i2;
import 'package:hollybike/event/screens/participations/event_participations_screen.dart'
    as _i4;
import 'package:hollybike/event/types/event_details.dart' as _i18;
import 'package:hollybike/event/types/minimal_event.dart' as _i17;
import 'package:hollybike/event/types/participation/event_participation.dart'
    as _i19;
import 'package:hollybike/image/bloc/image_list_bloc.dart' as _i22;
import 'package:hollybike/image/screens/image_gallery_page_view_screen.dart'
    as _i6;
import 'package:hollybike/journey/screen/import_gpx_tool_screen.dart' as _i7;
import 'package:hollybike/profile/screens/edit_profile_screen.dart' as _i1;
import 'package:hollybike/profile/screens/me_screen.dart' as _i10;
import 'package:hollybike/profile/screens/profile_screen.dart' as _i11;
import 'package:hollybike/search/screens/search_screen.dart' as _i12;
import 'package:hollybike/shared/routes/loading_route.dart' as _i8;
import 'package:hollybike/user_journey/screens/user_journey_map.dart' as _i14;

/// generated route for
/// [_i1.EditProfileScreen]
class EditProfileRoute extends _i15.PageRouteInfo<void> {
  const EditProfileRoute({List<_i15.PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return _i15.WrappedRoute(child: const _i1.EditProfileScreen());
    },
  );
}

/// generated route for
/// [_i2.EventCandidatesScreen]
class EventCandidatesRoute
    extends _i15.PageRouteInfo<EventCandidatesRouteArgs> {
  EventCandidatesRoute({
    _i16.Key? key,
    required int eventId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         EventCandidatesRoute.name,
         args: EventCandidatesRouteArgs(key: key, eventId: eventId),
         initialChildren: children,
       );

  static const String name = 'EventCandidatesRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventCandidatesRouteArgs>();
      return _i15.WrappedRoute(
        child: _i2.EventCandidatesScreen(key: args.key, eventId: args.eventId),
      );
    },
  );
}

class EventCandidatesRouteArgs {
  const EventCandidatesRouteArgs({this.key, required this.eventId});

  final _i16.Key? key;

  final int eventId;

  @override
  String toString() {
    return 'EventCandidatesRouteArgs{key: $key, eventId: $eventId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EventCandidatesRouteArgs) return false;
    return key == other.key && eventId == other.eventId;
  }

  @override
  int get hashCode => key.hashCode ^ eventId.hashCode;
}

/// generated route for
/// [_i3.EventDetailsScreen]
class EventDetailsRoute extends _i15.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i16.Key? key,
    required _i17.MinimalEvent event,
    bool animate = true,
    String uniqueKey = "default",
    List<_i15.PageRouteInfo>? children,
  }) : super(
         EventDetailsRoute.name,
         args: EventDetailsRouteArgs(
           key: key,
           event: event,
           animate: animate,
           uniqueKey: uniqueKey,
         ),
         initialChildren: children,
       );

  static const String name = 'EventDetailsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventDetailsRouteArgs>();
      return _i15.WrappedRoute(
        child: _i3.EventDetailsScreen(
          key: args.key,
          event: args.event,
          animate: args.animate,
          uniqueKey: args.uniqueKey,
        ),
      );
    },
  );
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.event,
    this.animate = true,
    this.uniqueKey = "default",
  });

  final _i16.Key? key;

  final _i17.MinimalEvent event;

  final bool animate;

  final String uniqueKey;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event, animate: $animate, uniqueKey: $uniqueKey}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EventDetailsRouteArgs) return false;
    return key == other.key &&
        event == other.event &&
        animate == other.animate &&
        uniqueKey == other.uniqueKey;
  }

  @override
  int get hashCode =>
      key.hashCode ^ event.hashCode ^ animate.hashCode ^ uniqueKey.hashCode;
}

/// generated route for
/// [_i4.EventParticipationsScreen]
class EventParticipationsRoute
    extends _i15.PageRouteInfo<EventParticipationsRouteArgs> {
  EventParticipationsRoute({
    _i16.Key? key,
    required _i18.EventDetails eventDetails,
    required List<_i19.EventParticipation> participationPreview,
    _i20.EventDetailsBloc? eventDetailsBloc,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         EventParticipationsRoute.name,
         args: EventParticipationsRouteArgs(
           key: key,
           eventDetails: eventDetails,
           participationPreview: participationPreview,
           eventDetailsBloc: eventDetailsBloc,
         ),
         initialChildren: children,
       );

  static const String name = 'EventParticipationsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventParticipationsRouteArgs>();
      return _i15.WrappedRoute(
        child: _i4.EventParticipationsScreen(
          key: args.key,
          eventDetails: args.eventDetails,
          participationPreview: args.participationPreview,
          eventDetailsBloc: args.eventDetailsBloc,
        ),
      );
    },
  );
}

class EventParticipationsRouteArgs {
  const EventParticipationsRouteArgs({
    this.key,
    required this.eventDetails,
    required this.participationPreview,
    this.eventDetailsBloc,
  });

  final _i16.Key? key;

  final _i18.EventDetails eventDetails;

  final List<_i19.EventParticipation> participationPreview;

  final _i20.EventDetailsBloc? eventDetailsBloc;

  @override
  String toString() {
    return 'EventParticipationsRouteArgs{key: $key, eventDetails: $eventDetails, participationPreview: $participationPreview, eventDetailsBloc: $eventDetailsBloc}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EventParticipationsRouteArgs) return false;
    return key == other.key &&
        eventDetails == other.eventDetails &&
        const _i21.ListEquality<_i19.EventParticipation>().equals(
          participationPreview,
          other.participationPreview,
        ) &&
        eventDetailsBloc == other.eventDetailsBloc;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      eventDetails.hashCode ^
      const _i21.ListEquality<_i19.EventParticipation>().hash(
        participationPreview,
      ) ^
      eventDetailsBloc.hashCode;
}

/// generated route for
/// [_i5.EventsScreen]
class EventsRoute extends _i15.PageRouteInfo<void> {
  const EventsRoute({List<_i15.PageRouteInfo>? children})
    : super(EventsRoute.name, initialChildren: children);

  static const String name = 'EventsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return _i15.WrappedRoute(child: const _i5.EventsScreen());
    },
  );
}

/// generated route for
/// [_i6.ImageGalleryViewScreen]
class ImageGalleryViewRoute
    extends _i15.PageRouteInfo<ImageGalleryViewRouteArgs> {
  ImageGalleryViewRoute({
    _i16.Key? key,
    required int imageIndex,
    required void Function() onLoadNextPage,
    required void Function() onRefresh,
    required _i22.ImageListBloc<dynamic> bloc,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         ImageGalleryViewRoute.name,
         args: ImageGalleryViewRouteArgs(
           key: key,
           imageIndex: imageIndex,
           onLoadNextPage: onLoadNextPage,
           onRefresh: onRefresh,
           bloc: bloc,
         ),
         initialChildren: children,
       );

  static const String name = 'ImageGalleryViewRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageGalleryViewRouteArgs>();
      return _i15.WrappedRoute(
        child: _i6.ImageGalleryViewScreen(
          key: args.key,
          imageIndex: args.imageIndex,
          onLoadNextPage: args.onLoadNextPage,
          onRefresh: args.onRefresh,
          bloc: args.bloc,
        ),
      );
    },
  );
}

class ImageGalleryViewRouteArgs {
  const ImageGalleryViewRouteArgs({
    this.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
    required this.bloc,
  });

  final _i16.Key? key;

  final int imageIndex;

  final void Function() onLoadNextPage;

  final void Function() onRefresh;

  final _i22.ImageListBloc<dynamic> bloc;

  @override
  String toString() {
    return 'ImageGalleryViewRouteArgs{key: $key, imageIndex: $imageIndex, onLoadNextPage: $onLoadNextPage, onRefresh: $onRefresh, bloc: $bloc}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImageGalleryViewRouteArgs) return false;
    return key == other.key &&
        imageIndex == other.imageIndex &&
        bloc == other.bloc;
  }

  @override
  int get hashCode => key.hashCode ^ imageIndex.hashCode ^ bloc.hashCode;
}

/// generated route for
/// [_i7.ImportGpxToolScreen]
class ImportGpxToolRoute extends _i15.PageRouteInfo<ImportGpxToolRouteArgs> {
  ImportGpxToolRoute({
    _i16.Key? key,
    required String url,
    required void Function(_i23.File) onGpxDownloaded,
    required void Function() onClose,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         ImportGpxToolRoute.name,
         args: ImportGpxToolRouteArgs(
           key: key,
           url: url,
           onGpxDownloaded: onGpxDownloaded,
           onClose: onClose,
         ),
         initialChildren: children,
       );

  static const String name = 'ImportGpxToolRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImportGpxToolRouteArgs>();
      return _i7.ImportGpxToolScreen(
        key: args.key,
        url: args.url,
        onGpxDownloaded: args.onGpxDownloaded,
        onClose: args.onClose,
      );
    },
  );
}

class ImportGpxToolRouteArgs {
  const ImportGpxToolRouteArgs({
    this.key,
    required this.url,
    required this.onGpxDownloaded,
    required this.onClose,
  });

  final _i16.Key? key;

  final String url;

  final void Function(_i23.File) onGpxDownloaded;

  final void Function() onClose;

  @override
  String toString() {
    return 'ImportGpxToolRouteArgs{key: $key, url: $url, onGpxDownloaded: $onGpxDownloaded, onClose: $onClose}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImportGpxToolRouteArgs) return false;
    return key == other.key && url == other.url;
  }

  @override
  int get hashCode => key.hashCode ^ url.hashCode;
}

/// generated route for
/// [_i8.LoadingRoute]
class LoadingRoute extends _i15.PageRouteInfo<void> {
  const LoadingRoute({List<_i15.PageRouteInfo>? children})
    : super(LoadingRoute.name, initialChildren: children);

  static const String name = 'LoadingRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i8.LoadingRoute();
    },
  );
}

/// generated route for
/// [_i9.LoginScreen]
class LoginRoute extends _i15.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i16.Key? key,
    required dynamic Function() onAuthSuccess,
    bool canPop = false,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(
           key: key,
           onAuthSuccess: onAuthSuccess,
           canPop: canPop,
         ),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i9.LoginScreen(
        key: args.key,
        onAuthSuccess: args.onAuthSuccess,
        canPop: args.canPop,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  final _i16.Key? key;

  final dynamic Function() onAuthSuccess;

  final bool canPop;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess, canPop: $canPop}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key && canPop == other.canPop;
  }

  @override
  int get hashCode => key.hashCode ^ canPop.hashCode;
}

/// generated route for
/// [_i10.MeScreen]
class MeRoute extends _i15.PageRouteInfo<void> {
  const MeRoute({List<_i15.PageRouteInfo>? children})
    : super(MeRoute.name, initialChildren: children);

  static const String name = 'MeRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i10.MeScreen();
    },
  );
}

/// generated route for
/// [_i11.ProfileScreen]
class ProfileRoute extends _i15.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i16.Key? key,
    String? urlId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(key: key, urlId: urlId),
         rawPathParams: {'id': urlId},
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProfileRouteArgs>(
        orElse: () => ProfileRouteArgs(urlId: pathParams.optString('id')),
      );
      return _i11.ProfileScreen(key: args.key, urlId: args.urlId);
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key, this.urlId});

  final _i16.Key? key;

  final String? urlId;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, urlId: $urlId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileRouteArgs) return false;
    return key == other.key && urlId == other.urlId;
  }

  @override
  int get hashCode => key.hashCode ^ urlId.hashCode;
}

/// generated route for
/// [_i12.SearchScreen]
class SearchRoute extends _i15.PageRouteInfo<void> {
  const SearchRoute({List<_i15.PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i12.SearchScreen();
    },
  );
}

/// generated route for
/// [_i13.SignupScreen]
class SignupRoute extends _i15.PageRouteInfo<void> {
  const SignupRoute({List<_i15.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i13.SignupScreen();
    },
  );
}

/// generated route for
/// [_i14.UserJourneyMapScreen]
class UserJourneyMapRoute extends _i15.PageRouteInfo<UserJourneyMapRouteArgs> {
  UserJourneyMapRoute({
    _i24.Key? key,
    required String fileUrl,
    required String title,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         UserJourneyMapRoute.name,
         args: UserJourneyMapRouteArgs(
           key: key,
           fileUrl: fileUrl,
           title: title,
         ),
         initialChildren: children,
       );

  static const String name = 'UserJourneyMapRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserJourneyMapRouteArgs>();
      return _i14.UserJourneyMapScreen(
        key: args.key,
        fileUrl: args.fileUrl,
        title: args.title,
      );
    },
  );
}

class UserJourneyMapRouteArgs {
  const UserJourneyMapRouteArgs({
    this.key,
    required this.fileUrl,
    required this.title,
  });

  final _i24.Key? key;

  final String fileUrl;

  final String title;

  @override
  String toString() {
    return 'UserJourneyMapRouteArgs{key: $key, fileUrl: $fileUrl, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserJourneyMapRouteArgs) return false;
    return key == other.key && fileUrl == other.fileUrl && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ fileUrl.hashCode ^ title.hashCode;
}
