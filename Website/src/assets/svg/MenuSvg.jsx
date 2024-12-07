import PropTypes from 'prop-types'; // Import for PropTypes validation

// MenuSvg component to display an animated menu icon
const MenuSvg = ({ openNavigation }) => {
  return (
    <svg
      className="overflow-visible"
      width="20"
      height="12"
      viewBox="0 0 20 12"
    >
      {/* Top or combined bar depending on openNavigation */}
      <rect
        className="transition-all origin-center"
        y={openNavigation ? "5" : "0"} // Adjust y-position based on state
        width="20"
        height="2"
        rx="1"
        fill="white"
        transform={`rotate(${openNavigation ? "45" : "0"})`} // Rotate when open
      />
      {/* Bottom or combined bar depending on openNavigation */}
      <rect
        className="transition-all origin-center"
        y={openNavigation ? "5" : "10"} // Adjust y-position based on state
        width="20"
        height="2"
        rx="1"
        fill="white"
        transform={`rotate(${openNavigation ? "-45" : "0"})`} // Rotate when open
      />
    </svg>
  );
};

// Define PropTypes for the component
MenuSvg.propTypes = {
  openNavigation: PropTypes.bool.isRequired, // openNavigation is required and should be a boolean
};

export default MenuSvg;
