import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import './l10n/gallery_localizations.dart';
import './data/gallery_options.dart';
import 'package:provider/provider.dart';
import './screens/crop_detail_screen.dart';

import './providers/app_localizations.dart';
import './providers/cropExpenses.dart';
import './providers/cropHarvest.dart';
import './screens/crops_overview_screen.dart';
import './screens/farmer_home_screen.dart';
import './screens/farmer_home_screen.dart';
import './screens/farmer_detail_screen.dart';

import './screens/crops_for_sale_overview_screen.dart';
import './screens/crops_for_sale_overview_screen_user.dart';
import './screens/crop_for_sale_detail_screen.dart';
import './screens/crop_for_sale_detail_screen_user.dart';
import './screens/crop_sale_anounce_screen.dart';
import './screens/user_crops_sale_screen.dart';
import './screens/login_page.dart';
import './screens/edit_expense_screen.dart';
import './providers/crops.dart';
import './providers/orchards.dart';
import './providers/marketPrices2.dart';
import './screens/edit_sale_screen.dart';
import './screens/sales_overview_screen.dart';
import './screens/market_prices_overview_screen3.dart';
import './screens/add_sale_screen.dart';
import './screens/user_crops_screen.dart';
import './screens/add_market_prices.dart';
import './screens/expenses_overview_screen.dart';
import './screens/splash_screen_New.dart';
import './screens/edit_crop_screen.dart';
import './screens/edit_orchard_screen.dart';
import './screens/forgot_password.dart';
import './screens/reset_password.dart';
import './providers/auth.dart';
import './providers/fertilizers.dart';
import './providers/facebook_auth.dart';
import './providers/crop_sales.dart';
import './screens/add_expense_screen.dart';
import './screens/add_fertilizer_pesticide.dart';
import './screens/pesticides_overview_screen.dart';
import './screens/edit_pesticides_screen.dart';
import './screens/add_harvest_screen.dart';
import './screens/edit_harvest_screen.dart';
import './screens/harvest_overview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/user_profiles.dart';
import './providers/users.dart';
import './providers/user_rating.dart';
import './screens/user_profile_screen.dart';
import './screens/splash_screen.dart';
import './screens/farmers_overview_screen.dart';
import './providers/fields.dart';
import './screens/fields_overview_screen.dart';
import './screens/field_detail_screen.dart';
import './screens/edit_field_screen.dart';
import './screens/crops_on_land_overview_screen.dart';
import './screens/user_fields_screen.dart';
import './widgets/crop_notes_list.dart';
import './providers/cropNotes.dart';
import './screens/add_notes_screen.dart';
import './screens/user_notes_screen.dart';
import './screens/notes_detail_screen.dart';
import './widgets/user_notes_item.dart';
import './widgets/machinery_grid.dart';
import './providers/machinery.dart';
import './screens/add_machinery_screen.dart';
import './screens/machinery_detail_screen.dart';
import './screens/user_machinery_screen.dart';

import './screens/contact_us_screen.dart';
import './screens/crop_investment_anounce_screen.dart';
import './screens/farmers_looking_for_investments_overview_screen.dart';
import './screens/crops_for_investment_details_screen.dart';
import './screens/guest_home_screen.dart';
import './screens/machinery_rental_anounce_screen.dart';
import './providers/images.dart';
import './screens/machinery_forSaleRental_overview_screen.dart';
import './screens/machinery_forSaleRental_detail_screen.dart';
import './widgets/machinery_forSaleRental_grid.dart';
import './screens/user_machinary_forSaleRental_screen.dart';
import './screens/my_sales_views_screen.dart';
import './screens/main_home_screen.dart';
import './screens/contact_us_pop_screen.dart';

void main() {
  //SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(lazy: false, create: (_) => Auth()),

        //ChangeNotifierProvider<Users>(lazy: false, create: (_) => Users(authToken, userId, _items)),

        ChangeNotifierProxyProvider<Auth, Orchards>(
          create: (_) => Orchards(null, null, []),
          update: (ctx, auth, previusOrchards) => Orchards(
              auth.token,
              auth.userId,
              previusOrchards == null ? [] : previusOrchards.items),
        ),

        ChangeNotifierProxyProvider<Auth, Crops>(
          create: (_) => Crops(null, null, []),
          update: (ctx, auth, previusCrops) => Crops(auth.token, auth.userId,
              previusCrops == null ? [] : previusCrops.items),
        ),

        ChangeNotifierProxyProvider<Auth, Fields>(
          create: (_) => Fields(null, null, []),
          update: (ctx, auth, previusCrops) => Fields(auth.token, auth.userId,
              previusCrops == null ? [] : previusCrops.items),
        ),

        ChangeNotifierProxyProvider<Auth, CropExpenses>(
          create: (_) => CropExpenses(null, null, []),
          update: (ctx, auth, previusCropExpenses) => CropExpenses(
              auth.token,
              auth.userId,
              previusCropExpenses == null ? [] : previusCropExpenses.items),
        ),

        ChangeNotifierProxyProvider<Auth, CropHarvest>(
          create: (_) => CropHarvest(null, null, []),
          update: (ctx, auth, previusCropHarvest) => CropHarvest(
              auth.token,
              auth.userId,
              previusCropHarvest == null ? [] : previusCropHarvest.items),
        ),

        ChangeNotifierProxyProvider<Auth, FertiPestis>(
          create: (_) => FertiPestis(null, null, []),
          update: (ctx, auth, previusFertiPestis) => FertiPestis(
              auth.token,
              auth.userId,
              previusFertiPestis == null ? [] : previusFertiPestis.items),
        ),

        ChangeNotifierProxyProvider<Auth, Sales>(
          create: (_) => Sales(null, null, []),
          update: (ctx, auth, previusSales) => Sales(auth.token, auth.userId,
              previusSales == null ? [] : previusSales.items),
        ),

        ChangeNotifierProxyProvider<Auth, MarketPrices2>(
          create: (_) => MarketPrices2(null, null, []),
          update: (ctx, auth, previusMarketPrices2) => MarketPrices2(
              auth.token,
              auth.userId,
              previusMarketPrices2 == null ? [] : previusMarketPrices2.items),
        ),

        ChangeNotifierProxyProvider<Auth, UserProfiles>(
          create: (_) => UserProfiles(null, null, null, null, null, null, []),
          update: (ctx, auth, previusUserProf) => UserProfiles(
              auth.token,
              auth.userId,
              auth.userType,
              auth.userEmail,
              auth.userFirstName,
              auth.userMobile,
              previusUserProf == null ? [] : previusUserProf.items),
        ),

        ChangeNotifierProxyProvider<Auth, Users>(
          create: (_) => Users(null, null, null, []),
          update: (ctx, auth, previusUserProf) => Users(
              auth.token,
              auth.userId,
              auth.userType,
              previusUserProf == null ? [] : previusUserProf.items),
        ),

        ChangeNotifierProxyProvider<Auth, UserRating>(
          create: (_) => UserRating(null, null, []),
          update: (ctx, auth, previusUserRatings) => UserRating(
              auth.token,
              auth.userId,
              previusUserRatings == null ? [] : previusUserRatings.items),
        ),

        ChangeNotifierProxyProvider<Auth, CropLandNotes>(
          create: (_) => CropLandNotes(null, null, []),
          update: (ctx, auth, previusCropNotes) => CropLandNotes(
              auth.token,
              auth.userId,
              previusCropNotes == null ? [] : previusCropNotes.items),
        ),

        ChangeNotifierProxyProvider<Auth, Machinery>(
          create: (_) => Machinery(null, null, []),
          update: (ctx, auth, previusMachinery) => Machinery(
              auth.token,
              auth.userId,
              previusMachinery == null ? [] : previusMachinery.items),
        ),

        ChangeNotifierProxyProvider<Auth, Images>(
          create: (_) => Images(null, null, []),
          update: (ctx, auth, previusImages) => Images(auth.token, auth.userId,
              previusImages == null ? [] : previusImages.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SmartFarmZ',
          theme: ThemeData(
              primaryColor: Colors.white,
              accentColor: Colors.amber,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? MainHomePage()
              :
              //CropsOverviewScreen() :
              FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen1()
                          : AuthCard(),
                  //AuthCard(),
                  //FacebookLogin(),
                ),

          routes: {
            CropDetailScreen.routeName: (ctx) => CropDetailScreen(),
            UserCropsScreen.routeName: (ctx) => UserCropsScreen(),
            EditExpenseScreen.routeName: (ctx) => EditExpenseScreen(),
            AddExpenseScreen.routeName: (ctx) => AddExpenseScreen(),
            EditCropScreen.routeName: (ctx) => EditCropScreen(),
            EditOrchardScreen.routeName: (ctx) => EditOrchardScreen(),
            ExpensesOverviewScreen.routeName: (ctx) => ExpensesOverviewScreen(),
            PesticidesOverviewScreen.routeName: (ctx) =>
                PesticidesOverviewScreen(),
            AddFertiPestiScreen.routeName: (ctx) => AddFertiPestiScreen(),
            EditFertiPestiScreen.routeName: (ctx) => EditFertiPestiScreen(),
            SalesOverviewScreen.routeName: (ctx) => SalesOverviewScreen(),
            AddSaleScreen.routeName: (ctx) => AddSaleScreen(),
            EditSaleScreen.routeName: (ctx) => EditSaleScreen(),
            CropsOverviewScreen.routeName: (ctx) => CropsOverviewScreen(),
            AuthCard.routeName: (ctx) => AuthCard(),
            GuestHomeScreen.routeName: (ctx) => GuestHomeScreen(),
            FarmerHomeScreen.routeName: (ctx) => FarmerHomeScreen(),
            AddMarketPricesScreen.routeName: (ctx) => AddMarketPricesScreen(),
            MarketPricesScreen.routeName: (ctx) => MarketPricesScreen(),
            UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
            ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
            FarmersOverviewScreen.routeName: (ctx) => FarmersOverviewScreen(),
            FarmerDetailScreen.routeName: (ctx) => FarmerDetailScreen(),
            CropsForSaleOverviewScreen.routeName: (ctx) =>
                CropsForSaleOverviewScreen(),
            CropsForSaleOverviewScreenUser.routeName: (ctx) =>
                CropsForSaleOverviewScreenUser(),
            CropForSaleDetailScreen.routeName: (ctx) =>
                CropForSaleDetailScreen(),
            CropForSaleDetailScreenUser.routeName: (ctx) =>
                CropForSaleDetailScreenUser(),
            CropSaleAnouncementScreen.routeName: (ctx) =>
                CropSaleAnouncementScreen(),
            UserCropsSaleScreen.routeName: (ctx) => UserCropsSaleScreen(),
            FieldDetailScreen.routeName: (ctx) => FieldDetailScreen(),
            FieldsOverviewScreen.routeName: (ctx) => FieldsOverviewScreen(),
            EditFieldScreen.routeName: (ctx) => EditFieldScreen(),
            CropsOnLandOverviewScreen.routeName: (ctx) =>
                CropsOnLandOverviewScreen(),
            UserFieldsScreen.routeName: (ctx) => UserFieldsScreen(),
            AddHarvestScreen.routeName: (ctx) => AddHarvestScreen(),
            HarvestOverviewScreen.routeName: (ctx) => HarvestOverviewScreen(),
            EditHarvestScreen.routeName: (ctx) => EditHarvestScreen(),
            CropNotesList.routeName: (ctx) => CropNotesList(),
            AddNotesScreen.routeName: (ctx) => AddNotesScreen(),
            UserNotesScreen.routeName: (ctx) => UserNotesScreen(),
            NotesDetailScreen.routeName: (ctx) => NotesDetailScreen(),
            MachineryGrid.routeName: (ctx) => MachineryGrid(),
            AddMachineryScreen.routeName: (ctx) => AddMachineryScreen(),
            MachineryDetailScreen.routeName: (ctx) => MachineryDetailScreen(),
            UserMachineryScreen.routeName: (ctx) => UserMachineryScreen(),
            ContactUs.routeName: (ctx) => ContactUs(),
            CropInvestmentSeekAnouncementScreen.routeName: (ctx) =>
                CropInvestmentSeekAnouncementScreen(),
            FarmersForInvestmentOverviewScreen.routeName: (ctx) =>
                FarmersForInvestmentOverviewScreen(),
            CropForInvestmentDetailScreen.routeName: (ctx) =>
                CropForInvestmentDetailScreen(),
            MachinerySaleAnouncementScreen.routeName: (ctx) =>
                MachinerySaleAnouncementScreen(),
            MachineryForSaleRentalOverviewScreen.routeName: (ctx) =>
                MachineryForSaleRentalOverviewScreen(),
            MachineryForSaleRentalGrid.routeName: (ctx) =>
                MachineryForSaleRentalGrid(),
            MachineryForSaleRentalDetailScreen.routeName: (ctx) =>
                MachineryForSaleRentalDetailScreen(),
            UserMachinerySaleRentalScreen.routeName: (ctx) =>
                UserMachinerySaleRentalScreen(),
            MySalesViews.routeName: (ctx) => MySalesViews(),
            MainHomePage.routeName: (ctx) => MainHomePage(),
            ContactUsPop.routeName: (ctx) => ContactUsPop(),
          },

          //Localization
          supportedLocales: GalleryLocalizations.supportedLocales,
          //locale: GalleryOptions.of(context).locale,
          localeResolutionCallback:
              (Locale locale, Iterable<Locale> supportedLocales) {
            return locale;
          },
          /*  [
        Locale('en', 'US'),
        Locale('te', 'TE'),
        Locale('sk', 'SK'),

      ], */

/*         localizationsDelegates: [

      ...GalleryLocalizations.localizationsDelegates,
              LocaleNamesLocalizationsDelegate(),
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ], */

          localizationsDelegates: const [
            ...GalleryLocalizations.localizationsDelegates,
            LocaleNamesLocalizationsDelegate()
          ],
          // Returns a locale which will be used by the app
          /*   localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        /* for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        } */
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      }, */
        ),
      ),
    );
  }
}
