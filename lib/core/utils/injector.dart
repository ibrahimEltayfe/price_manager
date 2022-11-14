import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:price_manager/core/utils/image_picker_helper.dart';
import 'package:price_manager/features/dashboard/domain/repositories/products_repository.dart';
import 'package:price_manager/features/dashboard/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:price_manager/features/home/data/data_sources/products_remote.dart';
import 'package:price_manager/features/home/domain/repositories/products_repository.dart';
import 'package:price_manager/features/profile/data/data_sources/profile_remote.dart';
import 'package:price_manager/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:price_manager/features/profile/domain/repositories/profile_repository.dart';
import '../../features/dashboard/data/data_sources/products_remote.dart';
import '../../features/dashboard/data/repositories/products_repository_impl.dart';
import '../../features/dashboard/presentation/bloc/admin_created_products/created_products_bloc.dart';
import '../../features/dashboard/presentation/bloc/admin_modified_products/modified_products_bloc.dart';
import '../../features/home/data/repositories/products_repository_impl.dart';
import '../../features/home/presentation/bloc/home/home_bloc.dart';
import '../../features/home/presentation/bloc/product_details/product_details_bloc.dart';
import '../../features/home/presentation/bloc/search_bloc/search_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../network_info/network_checker.dart';
import '../../features/auth/data/data_sources/firestore_auth_remote.dart';
import '../../features/auth/data/repositories/user_repo_impl.dart';
import '../../features/auth/domain/repositories/user_repo.dart';
import '../../features/auth/domain/use_cases/log_out_usecase.dart';
import '../../features/auth/domain/use_cases/login_with_email_usecase.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';

final injector = GetIt.instance;

void init(){
//! core
 //!errors
  //network_info
  injector.registerLazySingleton<NetworkInfo>(() => NetworkInfo(injector()));
  injector.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());

  //! utils
  injector.registerFactory<ImagePickerHelper>(() => ImagePickerHelper());

//! features ------------------------
  //! Auth
  //blocs
  injector.registerFactory<AuthBloc>(() => AuthBloc( injector(),injector()));

  //data sources
  injector.registerLazySingleton<AuthRemote>(() => AuthRemote());

  //repositories
  injector.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(injector(), injector()));

  //use cases
  injector.registerLazySingleton<LoginWithEmailUseCase>(() => LoginWithEmailUseCase(injector()));
  injector.registerLazySingleton<LogOutUseCase>(() => LogOutUseCase(injector()));

//----------------------------------------------------------------------------------------------------
  //! Home
  //blocs
  injector.registerFactory<HomeBloc>(() => HomeBloc(injector()));
  injector.registerFactory<ProductDetailsBloc>(() => ProductDetailsBloc(injector(),injector()));
  injector.registerFactory<SearchBloc>(() => SearchBloc(injector()));


  //data sources
  injector.registerLazySingleton<ProductsRemote>(() => ProductsRemote());

  //repositories
  injector.registerLazySingleton<ProductsRepository>(() => ProductsRepositoryImpl(injector(), injector()));

  //use cases

//----------------------------------------------------------------------------------------------------
  //! Dashboard
  //blocs
  injector.registerFactory<CreatedProductsBloc>(() => CreatedProductsBloc(injector()));
  injector.registerFactory<ModifiedProductsBloc>(() => ModifiedProductsBloc(injector()));
  injector.registerFactory<AddProductBloc>(() => AddProductBloc(injector(),injector()));

  //data sources
  injector.registerLazySingleton<DashboardRemote>(() => DashboardRemote());

  //repositories
  injector.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(injector(), injector()));

  //use cases

//----------------------------------------------------------------------------------------------------
  //! Profile
  //blocs
  injector.registerFactory<ProfileBloc>(() => ProfileBloc(injector()));

  //data sources
  injector.registerLazySingleton<ProfileRemote>(() => ProfileRemote());

  //repositories
  injector.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(injector(), injector()));

  //use cases
}