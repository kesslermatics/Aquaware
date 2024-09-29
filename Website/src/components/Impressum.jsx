import React from "react";

const Impressum = () => {
  return (
    <div className="w-full min-h-screen py-10 px-5 flex flex-col items-center">
      <div className="max-w-4xl w-full p-8 rounded-lg">
        <h1 className="text-3xl font-bold mb-6">
          Legal Disclosure (Impressum)
        </h1>

        <p className="mb-4">
          <strong>Information in accordance with Section 5 TMG</strong>
        </p>

        <p className="mb-4">
          <strong>Provider:</strong>
          <br />
          Robert Kessler <br />
          Richard Strauss Straße 85 <br />
          85057 Ingolstadt <br />
          Germany
        </p>

        <p className="mb-4">
          <strong>Contact Information:</strong>
          <br />
          Email:{" "}
          <a href="mailto:info@kesslermatics.com" className="text-blue-500">
            info@kesslermatics.com
          </a>
        </p>

        <p className="mb-4">
          <strong>VAT Identification Number</strong> <br />
          In accordance with Section 27 a of the German VAT Act: <br />
          DE360096261
        </p>

        <p className="mb-4">
          <strong>Business Form:</strong>
          <br />
          Sole Proprietorship
        </p>

        <p className="mb-4">
          <strong>Website Address:</strong> <br />
          <a href="https://aquaware.cloud" className="text-blue-500">
            aquaware.cloud
          </a>
        </p>

        <p className="mb-4">
          <strong>Disclaimer:</strong> <br />
          Despite careful monitoring, we assume no liability for the content of
          external links. The operators of the linked pages are solely
          responsible for their content.
        </p>

        <p className="mb-4">
          <strong>Terms and Conditions:</strong> <br />
          You can find our terms and conditions here:{" "}
          <a
            href="https://aquaware.cloud/terms-and-conditions"
            className="text-blue-500"
          >
            Terms and Conditions
          </a>
        </p>

        <p className="mb-4">
          <strong>Privacy Policy:</strong> <br />
          You can find our privacy policy here:{" "}
          <a href="https://aquaware.cloud/privacy" className="text-blue-500">
            Privacy Policy
          </a>
        </p>

        <p className="mt-6 text-sm text-gray-500">
          This legal notice is valid from today onwards.
        </p>
      </div>
    </div>
  );
};

export default Impressum;
