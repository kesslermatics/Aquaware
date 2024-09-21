import { loading } from "../assets";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faDroplet } from "@fortawesome/free-solid-svg-icons";

const Generating = ({ className }) => {
  return (
    <div
      className={`flex items-center h-[3.5rem] px-6 bg-n-8/80 rounded-[1.7rem] ${
        className || ""
      } text-base`}
    >
      <FontAwesomeIcon icon={faDroplet} className="mr-4" />
      Always know about your water quality
    </div>
  );
};

export default Generating;
