import { check } from "../assets";
import Button from "./Button";
import Section from "./Section";
import { LeftCurve, RightCurve } from "./design/ApiInfo";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCode } from "@fortawesome/free-solid-svg-icons";

const ApiInfo = () => {
  return (
    <Section crosses>
      <div className="container lg:flex">
        <div className="max-w-[25rem]">
          <h2 className="h2 mb-4 md:mb-8">
            Intuitive API Documentation to Get You Started
          </h2>

          <ul className="max-w-[22rem] mb-10 md:mb-14">
            <li className="mb-3 py-3">
              <div className="flex items-center">
                <img src={check} width={24} height={24} alt="check" />
                <h6 className="body-2 ml-5">Clear Documentation</h6>
              </div>
              <p className="body-2 mt-3 text-n-4">
                Our API documentation is intuitive and easy to follow, making it
                simple to get started.
              </p>
            </li>
            <li className="mb-3 py-3">
              <div className="flex items-center">
                <img src={check} width={24} height={24} alt="check" />
                <h6 className="body-2 ml-5">Seamless Integration</h6>
              </div>
              <p className="body-2 mt-3 text-n-4">
                Integrate your systems quickly and efficiently with our
                well-documented API.
              </p>
            </li>
          </ul>

          <Button href="/docs/index.html">Check the API Documentation</Button>
        </div>

        <div className="lg:ml-auto xl:w-[38rem] mt-4">
          <p className="body-2 mb-8 text-n-4 md:mb-16 lg:mb-32 lg:w-[22rem] lg:mx-auto">
            Our documentation ensures that you can get started quickly. Explore
            the resources and learn how to integrate seamlessly.
          </p>

          <div className="relative left-1/2 flex w-[22rem] aspect-square border border-n-6 rounded-full -translate-x-1/2 scale:75 md:scale-100">
            <div className="flex w-60 aspect-square m-auto border border-n-6 rounded-full">
              <div className="w-[6rem] aspect-square m-auto p-[0.2rem] bg-conic-gradient rounded-full">
                <div className="flex items-center justify-center w-full h-full bg-n-8 rounded-full">
                  <FontAwesomeIcon icon={faCode} />
                </div>
              </div>
            </div>

            <LeftCurve />
            <RightCurve />
          </div>
        </div>
      </div>
    </Section>
  );
};

export default ApiInfo;
