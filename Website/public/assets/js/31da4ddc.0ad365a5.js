"use strict";(self.webpackChunkclassic=self.webpackChunkclassic||[]).push([[985],{2650:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>l,contentTitle:()=>i,default:()=>m,frontMatter:()=>a,metadata:()=>o,toc:()=>d});var r=t(4848),s=t(8453);const a={sidebar_position:3},i="Get Total Entries for a Parameter",o={id:"dev-docs/measurement-management/get_total_entries",title:"Get Total Entries for a Parameter",description:"Endpoint",source:"@site/docs/dev-docs/measurement-management/get_total_entries.md",sourceDirName:"dev-docs/measurement-management",slug:"/dev-docs/measurement-management/get_total_entries",permalink:"/docs/dev-docs/measurement-management/get_total_entries",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"devDocSidebar",previous:{title:"Get All Values From Parameter",permalink:"/docs/dev-docs/measurement-management/get_all_values_from_parameter"},next:{title:"Get Latest Values from All Parameters",permalink:"/docs/dev-docs/measurement-management/get_latest_from_all_parameters"}},l={},d=[{value:"Endpoint",id:"endpoint",level:3},{value:"Description",id:"description",level:3},{value:"Authentication",id:"authentication",level:3},{value:"Request Parameters",id:"request-parameters",level:3},{value:"Example Request",id:"example-request",level:3},{value:"Response",id:"response",level:3},{value:"Use Case",id:"use-case",level:3}];function c(e){const n={code:"code",h1:"h1",h3:"h3",header:"header",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,s.R)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(n.header,{children:(0,r.jsx)(n.h1,{id:"get-total-entries-for-a-parameter",children:"Get Total Entries for a Parameter"})}),"\n",(0,r.jsx)(n.h3,{id:"endpoint",children:"Endpoint"}),"\n",(0,r.jsx)(n.p,{children:(0,r.jsx)(n.code,{children:"GET /api/environments/<int:environment_id>/values/parameters/<str:parameter_name>/total/"})}),"\n",(0,r.jsx)(n.h3,{id:"description",children:"Description"}),"\n",(0,r.jsx)(n.p,{children:"This API retrieves the total number of entries recorded for a specific water parameter in an environment. Useful for tracking the frequency of parameter measurements."}),"\n",(0,r.jsx)(n.h3,{id:"authentication",children:"Authentication"}),"\n",(0,r.jsx)(n.p,{children:"API Key"}),"\n",(0,r.jsx)(n.h3,{id:"request-parameters",children:"Request Parameters"}),"\n",(0,r.jsxs)(n.ul,{children:["\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.strong,{children:"environment_id"}),": The ID of the environment (integer)"]}),"\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.strong,{children:"parameter_name"}),": The name of the water parameter (string)"]}),"\n",(0,r.jsx)(n.li,{}),"\n"]}),"\n",(0,r.jsx)(n.h3,{id:"example-request",children:"Example Request"}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{children:"GET /api/environments/1/values/parameters/PH/total/\n"})}),"\n",(0,r.jsx)(n.h3,{id:"response",children:"Response"}),"\n",(0,r.jsxs)(n.ul,{children:["\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.strong,{children:"200 OK"}),": Total number of entries returned."]}),"\n"]}),"\n",(0,r.jsx)(n.pre,{children:(0,r.jsx)(n.code,{className:"language-json",children:'{\r\n  "total_entries": 120\r\n}\n'})}),"\n",(0,r.jsxs)(n.ul,{children:["\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.strong,{children:"404 Not Found"}),": The environment or parameter was not found."]}),"\n",(0,r.jsxs)(n.li,{children:[(0,r.jsx)(n.strong,{children:"400 Bad Request"}),": Invalid request parameters."]}),"\n"]}),"\n",(0,r.jsx)(n.h3,{id:"use-case",children:"Use Case"}),"\n",(0,r.jsx)(n.p,{children:"This endpoint can be helpful when you want to check how often a specific parameter, like pH or temperature, has been measured in an environment. It gives you the total count of recorded values for that parameter."})]})}function m(e={}){const{wrapper:n}={...(0,s.R)(),...e.components};return n?(0,r.jsx)(n,{...e,children:(0,r.jsx)(c,{...e})}):c(e)}},8453:(e,n,t)=>{t.d(n,{R:()=>i,x:()=>o});var r=t(6540);const s={},a=r.createContext(s);function i(e){const n=r.useContext(a);return r.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:i(e.components),r.createElement(a.Provider,{value:n},e.children)}}}]);