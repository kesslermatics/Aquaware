import { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEye, faEyeSlash } from "@fortawesome/free-solid-svg-icons";
import backgroundVideo from "../assets/bg-aquarium2.mp4";

const Signup = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const toggleConfirmPasswordVisibility = () => {
    setShowConfirmPassword(!showConfirmPassword);
  };

  return (
    <div className="w-full h-screen flex flex-col items-center justify-center bg-n-8">
      <video
        autoPlay
        loop
        muted
        className="absolute left-0 w-full h-full object-cover opacity-10 z-1"
      >
        <source src={backgroundVideo} type="video/mp4" />
        Your browser does not support the video tag.
      </video>
      <div className="w-full max-w-[500px] bg-n-1 rounded-lg shadow-lg p-8 z-2">
        <h1 className="text-3xl font-bold text-center text-n-8 mb-6">
          Sign Up
        </h1>

        <div className="w-full flex flex-col mb-4">
          <p className="text-base text-center mb-4 text-n-8">
            Become a part of a new generation now
          </p>
          <div className="flex space-x-4">
            <input
              type="text"
              placeholder="First Name"
              className="w-1/2 text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <input
              type="text"
              placeholder="Last Name"
              className="w-1/2 text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
          </div>
          <input
            type="email"
            placeholder="Email"
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
          <div className="relative w-full">
            <input
              type={showPassword ? "text" : "password"}
              placeholder="Password"
              className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <span
              className="absolute right-2 top-4 cursor-pointer text-gray-500"
              onClick={togglePasswordVisibility}
            >
              {showPassword ? (
                <FontAwesomeIcon icon={faEyeSlash} className="mr-4" />
              ) : (
                <FontAwesomeIcon icon={faEye} className="mr-4" />
              )}
            </span>
          </div>
          <div className="relative w-full">
            <input
              type={showConfirmPassword ? "text" : "password"}
              placeholder="Confirm Password"
              className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <span
              className="absolute right-2 top-4 cursor-pointer text-gray-500"
              onClick={toggleConfirmPasswordVisibility}
            >
              {showConfirmPassword ? (
                <FontAwesomeIcon icon={faEyeSlash} className="mr-4" />
              ) : (
                <FontAwesomeIcon icon={faEye} className="mr-4" />
              )}
            </span>
          </div>
        </div>

        <button className="w-full bg-n-15 text-white font-semibold rounded-md py-3 mb-4">
          Sign Up
        </button>

        <div className="w-full flex items-center justify-center relative mb-4">
          <div className="w-full h-[1px] bg-gray-300"></div>
          <p className="absolute bg-white px-4 text-gray-500">or</p>
        </div>

        <button className="w-full flex items-center justify-center bg-gray-100 text-n-8 font-semibold border border-gray-400 rounded-md py-3 mb-6">
          <img
            src="https://img.icons8.com/fluency/48/google-logo.png"
            alt="Google Icon"
            className="w-6 h-6 mr-2"
          />
          Sign Up With Google
        </button>

        <p className="text-center text-sm text-gray-600">
          Already have an account?{" "}
          <a className="text-blue-500 font-semibold" href="/login">
            Log in here
          </a>
        </p>
      </div>
    </div>
  );
};

export default Signup;
