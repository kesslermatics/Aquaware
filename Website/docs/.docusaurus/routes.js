import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/de/blog',
    component: ComponentCreator('/de/blog', 'f0f'),
    exact: true
  },
  {
    path: '/de/blog/archive',
    component: ComponentCreator('/de/blog/archive', '647'),
    exact: true
  },
  {
    path: '/de/blog/nitrification-process',
    component: ComponentCreator('/de/blog/nitrification-process', 'c12'),
    exact: true
  },
  {
    path: '/de/markdown-page',
    component: ComponentCreator('/de/markdown-page', 'de3'),
    exact: true
  },
  {
    path: '/de/docs',
    component: ComponentCreator('/de/docs', 'cb5'),
    routes: [
      {
        path: '/de/docs',
        component: ComponentCreator('/de/docs', 'de1'),
        routes: [
          {
            path: '/de/docs',
            component: ComponentCreator('/de/docs', 'c9d'),
            routes: [
              {
                path: '/de/docs/dev-docs/animal-detection/how_to_identify_any_fish',
                component: ComponentCreator('/de/docs/dev-docs/animal-detection/how_to_identify_any_fish', '8ed'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/animal-disease-detection/how_to_check_animal_for_diseases',
                component: ComponentCreator('/de/docs/dev-docs/animal-disease-detection/how_to_check_animal_for_diseases', 'fe4'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/adding-an-environment',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/adding-an-environment', '372'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/delete-environment',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/delete-environment', '197'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/get-all-environments',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/get-all-environments', 'bef'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/get-public-environments',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/get-public-environments', '214'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/update-environment',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/update-environment', 'bc5'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/add_water_values',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/add_water_values', '798'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/export_water_values',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/export_water_values', '649'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_alert_settings',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_alert_settings', 'e32'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_all_values_from_parameter', 'b90'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_latest_from_all_parameters', '8b4'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_total_entries',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_total_entries', '6cb'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/import_water_values',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/import_water_values', '6a0'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/save_alert_settings',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/save_alert_settings', 'a80'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/quick-start-guide',
                component: ComponentCreator('/de/docs/dev-docs/quick-start-guide', '695'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/create-an-account',
                component: ComponentCreator('/de/docs/dev-docs/user-management/create-an-account', 'fe4'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/jwt-tokens',
                component: ComponentCreator('/de/docs/dev-docs/user-management/jwt-tokens', '065'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/login',
                component: ComponentCreator('/de/docs/dev-docs/user-management/login', '56d'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/refresh-access-token',
                component: ComponentCreator('/de/docs/dev-docs/user-management/refresh-access-token', 'c1c'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/getting-started/adding-water-values',
                component: ComponentCreator('/de/docs/getting-started/adding-water-values', 'f9c'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/create-an-account',
                component: ComponentCreator('/de/docs/getting-started/create-an-account', 'd65'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/create-new-environment',
                component: ComponentCreator('/de/docs/getting-started/create-new-environment', '7b2'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/explore-the-dashboard',
                component: ComponentCreator('/de/docs/getting-started/explore-the-dashboard', 'cab'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/thank-you',
                component: ComponentCreator('/de/docs/getting-started/thank-you', 'd5c'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/use-the-app',
                component: ComponentCreator('/de/docs/getting-started/use-the-app', '239'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/welcome',
                component: ComponentCreator('/de/docs/getting-started/welcome', '399'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/real-world-example/Arduino',
                component: ComponentCreator('/de/docs/real-world-example/Arduino', '37a'),
                exact: true,
                sidebar: "realWorldSidebar"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    path: '/de/',
    component: ComponentCreator('/de/', '4d1'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
