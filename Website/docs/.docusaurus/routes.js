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
    component: ComponentCreator('/de/docs', 'a9f'),
    routes: [
      {
        path: '/de/docs',
        component: ComponentCreator('/de/docs', 'b94'),
        routes: [
          {
            path: '/de/docs',
            component: ComponentCreator('/de/docs', '7a5'),
            routes: [
              {
                path: '/de/docs/category/animal-detection',
                component: ComponentCreator('/de/docs/category/animal-detection', '136'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/animal-disease-detection',
                component: ComponentCreator('/de/docs/category/animal-disease-detection', 'c87'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/environments',
                component: ComponentCreator('/de/docs/category/environments', '495'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/measurements',
                component: ComponentCreator('/de/docs/category/measurements', '793'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/user-management',
                component: ComponentCreator('/de/docs/category/user-management', 'e04'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/animal-detection/how_to_identify_any_fish',
                component: ComponentCreator('/de/docs/getting-started/animal-detection/how_to_identify_any_fish', '375'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/animal-disease-detection/how_to_check_animal_for_diseases',
                component: ComponentCreator('/de/docs/getting-started/animal-disease-detection/how_to_check_animal_for_diseases', '7c2'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/adding-an-environment',
                component: ComponentCreator('/de/docs/getting-started/environment-management/adding-an-environment', 'ebf'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/delete-environment',
                component: ComponentCreator('/de/docs/getting-started/environment-management/delete-environment', '1f1'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/get-all-environments',
                component: ComponentCreator('/de/docs/getting-started/environment-management/get-all-environments', '294'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/get-public-environments',
                component: ComponentCreator('/de/docs/getting-started/environment-management/get-public-environments', '77f'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/update-environment',
                component: ComponentCreator('/de/docs/getting-started/environment-management/update-environment', '04b'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/add_water_values',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/add_water_values', '819'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/export_water_values',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/export_water_values', '1fd'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_alert_settings',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_alert_settings', '37d'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_all_values_from_parameter', 'b65'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_latest_from_all_parameters', '3d7'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_total_entries',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_total_entries', '8d5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/import_water_values',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/import_water_values', 'fcd'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/save_alert_settings',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/save_alert_settings', '937'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/quick-start-guide',
                component: ComponentCreator('/de/docs/getting-started/quick-start-guide', 'e42'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/create-an-account',
                component: ComponentCreator('/de/docs/getting-started/user-management/create-an-account', '974'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/jwt-tokens',
                component: ComponentCreator('/de/docs/getting-started/user-management/jwt-tokens', '50a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/login',
                component: ComponentCreator('/de/docs/getting-started/user-management/login', 'e35'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/refresh-access-token',
                component: ComponentCreator('/de/docs/getting-started/user-management/refresh-access-token', 'a40'),
                exact: true,
                sidebar: "tutorialSidebar"
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
