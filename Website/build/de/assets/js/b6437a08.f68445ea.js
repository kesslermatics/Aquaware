"use strict";(self.webpackChunkclassic=self.webpackChunkclassic||[]).push([[4024],{2242:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>l,contentTitle:()=>a,default:()=>c,frontMatter:()=>i,metadata:()=>o,toc:()=>d});var r=n(4848),s=n(8453);const i={sidebar_position:5},a="Export Water Values",o={id:"getting-started/measurement-management/export_water_values",title:"Export Water Values",description:"Endpoint",source:"@site/docs/getting-started/measurement-management/export_water_values.md",sourceDirName:"getting-started/measurement-management",slug:"/getting-started/measurement-management/export_water_values",permalink:"/de/docs/getting-started/measurement-management/export_water_values",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:5,frontMatter:{sidebar_position:5},sidebar:"tutorialSidebar",previous:{title:"Get Latest Values from All Parameters",permalink:"/de/docs/getting-started/measurement-management/get_latest_from_all_parameters"},next:{title:"Import Water Values",permalink:"/de/docs/getting-started/measurement-management/import_water_values"}},l={},d=[{value:"Endpoint",id:"endpoint",level:3},{value:"Description",id:"description",level:3},{value:"Authentication",id:"authentication",level:3},{value:"Request Parameters",id:"request-parameters",level:3},{value:"Example Request",id:"example-request",level:3},{value:"Response",id:"response",level:3}];function u(e){const t={admonition:"admonition",code:"code",h1:"h1",h3:"h3",header:"header",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,s.R)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(t.header,{children:(0,r.jsx)(t.h1,{id:"export-water-values",children:"Export Water Values"})}),"\n",(0,r.jsx)(t.h3,{id:"endpoint",children:"Endpoint"}),"\n",(0,r.jsx)(t.p,{children:(0,r.jsx)(t.code,{children:"GET /measurements/environments/<int:environment_id>/export/"})}),"\n",(0,r.jsx)(t.h3,{id:"description",children:"Description"}),"\n",(0,r.jsx)(t.p,{children:"This API allows users to export the water values of an environment as a CSV file. It is particularly useful for backing up data, sharing with third parties, or for further data analysis in spreadsheet software."}),"\n",(0,r.jsx)(t.h3,{id:"authentication",children:"Authentication"}),"\n",(0,r.jsx)(t.p,{children:"JWT Token (Access Token required)"}),"\n",(0,r.jsx)(t.h3,{id:"request-parameters",children:"Request Parameters"}),"\n",(0,r.jsxs)(t.ul,{children:["\n",(0,r.jsxs)(t.li,{children:[(0,r.jsx)(t.strong,{children:"environment_id"}),": The ID of the environment (integer)"]}),"\n"]}),"\n",(0,r.jsx)(t.h3,{id:"example-request",children:"Example Request"}),"\n",(0,r.jsx)(t.pre,{children:(0,r.jsx)(t.code,{children:"GET /measurements/environments/1234/export/\n"})}),"\n",(0,r.jsx)(t.h3,{id:"response",children:"Response"}),"\n",(0,r.jsxs)(t.ul,{children:["\n",(0,r.jsxs)(t.li,{children:[(0,r.jsx)(t.strong,{children:"200 OK"}),": Returns a CSV file containing water values for the environment."]}),"\n"]}),"\n",(0,r.jsx)(t.pre,{children:(0,r.jsx)(t.code,{children:"Measured At, pH, Temperature, pH_unit, Temperature_unit\r\n2024-09-24 10:30:00, 7.2, 24.5, pH, C\r\n2024-09-23 10:30:00, 7.0, 24.2, pH, C\n"})}),"\n",(0,r.jsxs)(t.ul,{children:["\n",(0,r.jsxs)(t.li,{children:[(0,r.jsx)(t.strong,{children:"404 Not Found"}),": The environment was not found or does not belong to the user."]}),"\n",(0,r.jsxs)(t.li,{children:[(0,r.jsx)(t.strong,{children:"400 Bad Request"}),": Invalid request."]}),"\n"]}),"\n",(0,r.jsx)(t.admonition,{title:"Keep in mind",type:"danger",children:(0,r.jsx)(t.p,{children:"When using an Arduino to upload water values asynchronously, it's possible that the values for different parameters might have a time difference of a few seconds. This can lead to slight discrepancies in the time recorded for each parameter. To mitigate this, we have implemented a system that groups all measurements taken within a 5-minute window. This means that exported measurements will always be summarized and exist within 5-minute intervals, ensuring consistency across parameters and reducing the impact of small time differences."})})]})}function c(e={}){const{wrapper:t}={...(0,s.R)(),...e.components};return t?(0,r.jsx)(t,{...e,children:(0,r.jsx)(u,{...e})}):u(e)}},8453:(e,t,n)=>{n.d(t,{R:()=>a,x:()=>o});var r=n(6540);const s={},i=r.createContext(s);function a(e){const t=r.useContext(i);return r.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function o(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:a(e.components),r.createElement(i.Provider,{value:t},e.children)}}}]);