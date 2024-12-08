import React from "react";

const Docs = () => {
  return (
    <div style={{ height: "100vh", width: "100%" }}>
      <iframe
        src="/docs/getting-started/quick-start-guide/index.html"
        title="Docusaurus Documentation"
        style={{
          width: "100vw",
          height: "100vh",
          border: "none",
          overflow: "hidden",
        }}
      />
    </div>
  );
};

export default Docs;
