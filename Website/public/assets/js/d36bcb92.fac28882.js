"use strict";(self.webpackChunkclassic=self.webpackChunkclassic||[]).push([[2442],{6603:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>o,contentTitle:()=>i,default:()=>u,frontMatter:()=>a,metadata:()=>l,toc:()=>d});var s=n(4848),r=n(8453);const a={sidebar_position:7},i="Save Alert Settings",l={id:"getting-started/measurement-management/save_alert_settings",title:"Save Alert Settings",description:"Alerts are only available in the Advanced or Business plan. You can set threshold alerts for your water parameters through the API or directly in the app. Once set, alerts will notify you via email when a water parameter exceeds the defined threshold. The emails are sent to the account's registered email address.",source:"@site/docs/getting-started/measurement-management/save_alert_settings.md",sourceDirName:"getting-started/measurement-management",slug:"/getting-started/measurement-management/save_alert_settings",permalink:"/docs/getting-started/measurement-management/save_alert_settings",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:7,frontMatter:{sidebar_position:7},sidebar:"tutorialSidebar",previous:{title:"Import Water Values",permalink:"/docs/getting-started/measurement-management/import_water_values"},next:{title:"Get Alert Settings",permalink:"/docs/getting-started/measurement-management/get_alert_settings"}},o={},d=[{value:"API Endpoint",id:"api-endpoint",level:2},{value:"Request Body",id:"request-body",level:3},{value:"Example",id:"example",level:3},{value:"Response",id:"response",level:2}];function c(e){const t={code:"code",h1:"h1",h2:"h2",h3:"h3",header:"header",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,r.R)(),...e.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(t.header,{children:(0,s.jsx)(t.h1,{id:"save-alert-settings",children:"Save Alert Settings"})}),"\n",(0,s.jsxs)(t.p,{children:["Alerts are only available in the ",(0,s.jsx)(t.strong,{children:"Advanced"})," or ",(0,s.jsx)(t.strong,{children:"Business"})," plan. You can set threshold alerts for your water parameters through the API or directly in the app. Once set, alerts will notify you via email when a water parameter exceeds the defined threshold. The emails are sent to the account's registered email address."]}),"\n",(0,s.jsx)(t.h2,{id:"api-endpoint",children:"API Endpoint"}),"\n",(0,s.jsx)(t.p,{children:(0,s.jsx)(t.code,{children:"POST /environments/<environment_id>/save-alert-settings/"})}),"\n",(0,s.jsx)(t.h3,{id:"request-body",children:"Request Body"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-json",children:'{\r\n  "parameter": "<parameter_name>",\r\n  "under_value": "<threshold_under_value>",\r\n  "above_value": "<threshold_above_value>"\r\n}\n'})}),"\n",(0,s.jsx)(t.h3,{id:"example",children:"Example"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-bash",children:'curl -X POST "https://dev.aquaware.cloud/api/environments/<environment_id>/save-alert-settings/" \\\r\n-H "Authorization: Bearer <your_access_token>" \\\r\n-H "Content-Type: application/json" \\\r\n-d \'{\r\n    "parameter": "pH",\r\n    "under_value": 6.5,\r\n    "above_value": 8.0\r\n}\'\n'})}),"\n",(0,s.jsx)(t.h2,{id:"response",children:"Response"}),"\n",(0,s.jsxs)(t.ul,{children:["\n",(0,s.jsxs)(t.li,{children:[(0,s.jsx)(t.strong,{children:"200 OK"}),": Alert settings saved successfully."]}),"\n",(0,s.jsxs)(t.li,{children:[(0,s.jsx)(t.strong,{children:"400 Bad Request"}),": Invalid input."]}),"\n",(0,s.jsxs)(t.li,{children:[(0,s.jsx)(t.strong,{children:"404 Not Found"}),": Environment not found."]}),"\n"]})]})}function u(e={}){const{wrapper:t}={...(0,r.R)(),...e.components};return t?(0,s.jsx)(t,{...e,children:(0,s.jsx)(c,{...e})}):c(e)}},8453:(e,t,n)=>{n.d(t,{R:()=>i,x:()=>l});var s=n(6540);const r={},a=s.createContext(r);function i(e){const t=s.useContext(a);return s.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function l(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(r):e.components||r:i(e.components),s.createElement(a.Provider,{value:t},e.children)}}}]);