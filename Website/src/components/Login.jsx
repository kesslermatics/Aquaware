import { useState } from "react";
import { GoogleLogin } from "@react-oauth/google";
import Cookies from "js-cookie";
import backgroundVideo from "../assets/bg-aquarium2.mp4";

const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  // Handle regular login
  const handleLogin = async () => {
    const response = await fetch(
      "https://dev.aquaware.cloud/api/users/login/",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: email,
          password: password,
        }),
        credentials: "include",
      }
    );

    const data = await response.json();

    if (response.ok) {
      Cookies.set("access_token", data.access, { expires: 1 });
      Cookies.set("refresh_token", data.refresh, { expires: 7 });
      window.location.href = "/dashboard"; // Redirect after successful login
    } else {
      setError("Invalid login credentials");
    }
  };

  // Handle Google login
  const handleGoogleLogin = async (tokenResponse) => {
    const token = tokenResponse.credential;

    const response = await fetch(
      "https://dev.aquaware.cloud/api/users/google-login/",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          token: token,
        }),
        credentials: "include",
      }
    );

    const data = await response.json();

    if (response.ok) {
      Cookies.set("access_token", data.access, { expires: 1 });
      Cookies.set("refresh_token", data.refresh, { expires: 7 });
      window.location.href = "/dashboard"; // Redirect after successful Google login
    } else {
      setError(data.error || "Google login failed");
    }
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
        <h1 className="text-3xl font-bold text-center text-n-8 mb-6">Login</h1>

        {error && <p className="text-red-500 text-center mb-4">{error}</p>}

        <div className="w-full flex flex-col mb-4">
          <p className="text-base text-center mb-4 text-n-8">
            Welcome Back! Please enter your details.
          </p>
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
        </div>

        <button
          onClick={handleLogin}
          className="w-full bg-n-15 text-white font-semibold rounded-md py-3 mb-4"
        >
          Log in
        </button>

        <div className="w-full flex items-center justify-center relative mb-4">
          <div className="w-full h-[1px] bg-gray-300"></div>
          <p className="absolute bg-white px-4 text-gray-500">or</p>
        </div>

        <div className="w-full flex items-center justify-center text-n-8 font-semibold rounded-md py-3 mb-6">
          <GoogleLogin
            onSuccess={handleGoogleLogin}
            onError={() => setError("Google login failed")}
            useOneTap
          />
        </div>

        <p className="text-center text-sm text-gray-600 mt-6">
          Don’t have an account?{" "}
          <a
            className="text-blue-500 font-semibold cursor-pointer"
            href="/signup"
          >
            Sign up for free
          </a>
        </p>
      </div>
    </div>
  );
};

export default Login;