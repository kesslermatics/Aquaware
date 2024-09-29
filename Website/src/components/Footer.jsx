import React from "react";
import Section from "./Section";

const Footer = () => {
  return (
    <Section crosses className="!px-0 !py-10">
      <div className="container flex justify-between items-center gap-10 max-sm:flex-col">
        <p className="caption text-n-4">
          © {new Date().getFullYear()}. All rights reserved.
        </p>
        <div className="flex gap-5 ml-auto">
          <a
            href="/impressum"
            className="text-n-4 text-sm hover:text-n-1 transition-colors"
          >
            Impressum
          </a>
          <a
            href="/privacy"
            className="text-n-4 text-sm hover:text-n-1 transition-colors"
          >
            Privacy
          </a>
          <a
            href="/terms-and-conditions"
            className="text-n-4 text-sm hover:text-n-1 transition-colors"
          >
            Terms and Conditions
          </a>
        </div>
      </div>
    </Section>
  );
};

export default Footer;
