import PropTypes from 'prop-types'; // Import for PropTypes
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTemperatureThreeQuarters } from "@fortawesome/free-solid-svg-icons";

// Notification component with className and title props
const Notification = ({ className, title }) => {
  return (
    <div
      className={`${
        className || ""
      } flex items-center p-4 pr-6 bg-n-9/40 backdrop-blur border border-n-1/10 rounded-2xl gap-5`}
    >
      {/* Icon representing the notification */}
      <FontAwesomeIcon
        size="3x"
        alt="Temperature" // Accessibility: alternative text for screen readers
        className="rounded-xl"
        icon={faTemperatureThreeQuarters}
      />

      {/* Main content section */}
      <div className="flex-1">
        {/* Notification title */}
        <h6 className="mb-1 font-semibold text-base">{title}</h6>

        {/* Additional information (hardcoded "1m ago") */}
        <div className="flex items-center justify-between">
          <div className="body-2 text-n-13">1m ago</div>
        </div>
      </div>
    </div>
  );
};

// Define PropTypes to validate props
Notification.propTypes = {
  className: PropTypes.string, // className should be a string (optional)
  title: PropTypes.string.isRequired, // title should be a string and is required
};

// Default props to ensure graceful fallback
Notification.defaultProps = {
  className: '', // Default to an empty string if className is not provided
};

export default Notification;
