import 'package:ajenda_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ajenda_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:ajenda_app/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/network/api_service.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage_service.dart';

// Auth
import '../features/Note/data/data_source/note_remote_data_source.dart';
import '../features/Note/data/repository/note_repository_impl.dart';
import '../features/Note/domain/note_repository.dart';

import '../features/Note/logic/note_cubit/note_cubit.dart';

import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/logic/auth_cubit/auth_cubit.dart';

// Profile

// Workspace
import '../features/space/logic/deleted_space_cubit/deleted_space_cubit.dart';
import '../features/task/data/data_source/subtask_remote_data_source.dart';
import '../features/task/data/data_source/task_remote_data_source.dart';
import '../features/task/data/repository/subtask_repository_impl.dart';
import '../features/task/data/repository/task_repository_impl.dart';
import '../features/task/domain/subtask_repository.dart';
import '../features/task/domain/task_repository.dart';
import '../features/task/logic/subtask_cubit/subtask_cubit.dart';
import '../features/task/logic/task_cubit/task_cubit.dart';
import '../features/workspace/data/data_source/workspace_remote_data_source.dart';
import '../features/workspace/data/repository/workspace_repository_impl.dart';
import '../features/workspace/domain/workspace_repository.dart';

// Space
import '../features/space/data/data_source/space_remote_data_source.dart';
import '../features/space/data/repository/space_repository_impl.dart';
import '../features/space/domain/space_repository.dart';
import '../features/space/logic/space_cubit/space_cubit.dart';
import '../features/workspace/logic/current_user_permissions_cubit/current_user_permissions_cubit.dart';
import '../features/workspace/logic/member_cubit/member_cubit.dart';
import '../features/workspace/logic/permission_cubit/permission_cubit.dart';
import '../features/workspace/logic/workspace_cubit/workspace_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // ── Core ──────────────────────────────────────────────────────

  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // ── Auth ──────────────────────────────────────────────────────

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      storage: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>(), getIt<SecureStorageService>()),
  );

  // ── Profile ───────────────────────────────────────────────────

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () =>
        ProfileCubit(getIt<ProfileRepository>(), getIt<SecureStorageService>()),
  );

  // ── Workspace ─────────────────────────────────────────────────

  getIt.registerLazySingleton<WorkspaceRemoteDataSource>(
    () => WorkspaceRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepositoryImpl(getIt<WorkspaceRemoteDataSource>()),
  );

  getIt.registerFactory<WorkspaceCubit>(
    () => WorkspaceCubit(getIt<WorkspaceRepository>()),
  );

  getIt.registerFactory<MembersCubit>(
    () => MembersCubit(getIt<WorkspaceRepository>()),
  );

  getIt.registerFactory<PermissionsCubit>(
    () => PermissionsCubit(getIt<WorkspaceRepository>()),
  );

  //  CurrentUserPermissionsCubit
  getIt.registerFactory(
    () => CurrentUserPermissionsCubit(repository: getIt(), storage: getIt()),
  );

  // ── Space ─────────────────────────────────────────────────────

  getIt.registerLazySingleton<SpaceRemoteDataSource>(
    () => SpaceRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<SpaceRepository>(
    () => SpaceRepositoryImpl(getIt<SpaceRemoteDataSource>()),
  );

  getIt.registerFactory<SpaceCubit>(() => SpaceCubit(getIt<SpaceRepository>()));

  getIt.registerFactory<DeletedSpaceCubit>(
    () => DeletedSpaceCubit(getIt<SpaceRepository>()),
  );

  // ── Task ──────────────────────────────────────────────────────

  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt<TaskRemoteDataSource>()),
  );

  getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt<TaskRepository>()));

  // ── SubTask ───────────────────────────────────────────────────
  // ⚠️ registerFactory مش registerLazySingleton
  // عشان SubTaskCubit بياخد TaskCubit كـ dependency
  // وكل TaskCubit instance لازم يكون مربوط بـ SubTaskCubit خاص بيه

  getIt.registerLazySingleton<SubTaskRemoteDataSource>(
    () => SubTaskRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<SubTaskRepository>(
    () => SubTaskRepositoryImpl(getIt<SubTaskRemoteDataSource>()),
  );


  // SubTask — محتاج TaskCubit كـ param

  getIt.registerFactoryParam<SubTaskCubit, TaskCubit, void>(
    (taskCubit, _) => SubTaskCubit(getIt(), taskCubit),
  );

  // Notes
  getIt.registerLazySingleton<NoteRemoteDataSource>(
        () => NoteRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<NoteRepository>(
        () => NoteRepositoryImpl(getIt<NoteRemoteDataSource>()),
  );
  getIt.registerFactory<NoteCubit>(
        () => NoteCubit(getIt<NoteRepository>()),
  );




  // ══════════════════════════════════════════════════
  // الكود الفعلي — أضيفي السطر ده بس لو مش موجود
  // ══════════════════════════════════════════════════

  /*

  // في setupDependencies():

  getIt.registerFactory(() => CurrentUserPermissionsCubit(
    repository: getIt<WorkspaceRepository>(),
    storage: getIt<SecureStorageService>(),
  ));

  // لو SubTaskCubit مش متسجل بـ registerFactoryParam:
  getIt.registerFactoryParam<SubTaskCubit, TaskCubit, void>(
    (taskCubit, _) => SubTaskCubit(getIt<SubTaskRepository>(), taskCubit),
  );

*/
}
