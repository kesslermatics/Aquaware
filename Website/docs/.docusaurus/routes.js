import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/__docusaurus/debug',
    component: ComponentCreator('/__docusaurus/debug', '5ff'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/config',
    component: ComponentCreator('/__docusaurus/debug/config', '5ba'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/content',
    component: ComponentCreator('/__docusaurus/debug/content', 'a2b'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/globalData',
    component: ComponentCreator('/__docusaurus/debug/globalData', 'c3c'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/metadata',
    component: ComponentCreator('/__docusaurus/debug/metadata', '156'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/registry',
    component: ComponentCreator('/__docusaurus/debug/registry', '88c'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/routes',
    component: ComponentCreator('/__docusaurus/debug/routes', '000'),
    exact: true
  },
  {
    path: '/blog',
    component: ComponentCreator('/blog', 'b2f'),
    exact: true
  },
  {
    path: '/blog/archive',
    component: ComponentCreator('/blog/archive', '182'),
    exact: true
  },
  {
    path: '/blog/authors',
    component: ComponentCreator('/blog/authors', '0b7'),
    exact: true
  },
  {
    path: '/blog/authors/all-sebastien-lorber-articles',
    component: ComponentCreator('/blog/authors/all-sebastien-lorber-articles', '4a1'),
    exact: true
  },
  {
    path: '/blog/authors/yangshun',
    component: ComponentCreator('/blog/authors/yangshun', 'a68'),
    exact: true
  },
  {
    path: '/blog/first-blog-post',
    component: ComponentCreator('/blog/first-blog-post', '89a'),
    exact: true
  },
  {
    path: '/blog/long-blog-post',
    component: ComponentCreator('/blog/long-blog-post', '9ad'),
    exact: true
  },
  {
    path: '/blog/mdx-blog-post',
    component: ComponentCreator('/blog/mdx-blog-post', 'e9f'),
    exact: true
  },
  {
    path: '/blog/tags',
    component: ComponentCreator('/blog/tags', '287'),
    exact: true
  },
  {
    path: '/blog/tags/docusaurus',
    component: ComponentCreator('/blog/tags/docusaurus', '704'),
    exact: true
  },
  {
    path: '/blog/tags/facebook',
    component: ComponentCreator('/blog/tags/facebook', '858'),
    exact: true
  },
  {
    path: '/blog/tags/hello',
    component: ComponentCreator('/blog/tags/hello', '299'),
    exact: true
  },
  {
    path: '/blog/tags/hola',
    component: ComponentCreator('/blog/tags/hola', '00d'),
    exact: true
  },
  {
    path: '/blog/welcome',
    component: ComponentCreator('/blog/welcome', 'd2b'),
    exact: true
  },
  {
    path: '/markdown-page',
    component: ComponentCreator('/markdown-page', '3d7'),
    exact: true
  },
  {
    path: '/docs',
    component: ComponentCreator('/docs', 'c72'),
    routes: [
      {
        path: '/docs',
        component: ComponentCreator('/docs', 'e16'),
        routes: [
          {
            path: '/docs',
            component: ComponentCreator('/docs', '323'),
            routes: [
              {
                path: '/docs/category/environments',
                component: ComponentCreator('/docs/category/environments', 'e65'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/category/fish-disease-detection',
                component: ComponentCreator('/docs/category/fish-disease-detection', 'dd5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/category/measurements',
                component: ComponentCreator('/docs/category/measurements', '42a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/category/user-management',
                component: ComponentCreator('/docs/category/user-management', '395'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/environment-management/adding-an-environment',
                component: ComponentCreator('/docs/getting-started/environment-management/adding-an-environment', '8e2'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/environment-management/delete-environment',
                component: ComponentCreator('/docs/getting-started/environment-management/delete-environment', '2ef'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/environment-management/get-all-environments',
                component: ComponentCreator('/docs/getting-started/environment-management/get-all-environments', '681'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/environment-management/get-public-environments',
                component: ComponentCreator('/docs/getting-started/environment-management/get-public-environments', 'ffc'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/environment-management/update-environment',
                component: ComponentCreator('/docs/getting-started/environment-management/update-environment', 'd5b'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/fish-disease-detection/how_to_check_fish_for_diseases',
                component: ComponentCreator('/docs/getting-started/fish-disease-detection/how_to_check_fish_for_diseases', 'af0'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/add_water_values',
                component: ComponentCreator('/docs/getting-started/measurement-management/add_water_values', '097'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/export_water_values',
                component: ComponentCreator('/docs/getting-started/measurement-management/export_water_values', '178'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/get_alert_settings',
                component: ComponentCreator('/docs/getting-started/measurement-management/get_alert_settings', 'a70'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/docs/getting-started/measurement-management/get_all_values_from_parameter', '538'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/docs/getting-started/measurement-management/get_latest_from_all_parameters', '6ce'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/get_total_entries',
                component: ComponentCreator('/docs/getting-started/measurement-management/get_total_entries', '148'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/import_water_values',
                component: ComponentCreator('/docs/getting-started/measurement-management/import_water_values', 'b2e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/measurement-management/save_alert_settings',
                component: ComponentCreator('/docs/getting-started/measurement-management/save_alert_settings', '35f'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/quick-start-guide',
                component: ComponentCreator('/docs/getting-started/quick-start-guide', 'd3e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/user-management/create-an-account',
                component: ComponentCreator('/docs/getting-started/user-management/create-an-account', '079'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/user-management/jwt-tokens',
                component: ComponentCreator('/docs/getting-started/user-management/jwt-tokens', '575'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/user-management/login',
                component: ComponentCreator('/docs/getting-started/user-management/login', 'dca'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/getting-started/user-management/refresh-access-token',
                component: ComponentCreator('/docs/getting-started/user-management/refresh-access-token', '5ae'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/real-world-example/Arduino',
                component: ComponentCreator('/docs/real-world-example/Arduino', 'd1d'),
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
    path: '/',
    component: ComponentCreator('/', '2e1'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
