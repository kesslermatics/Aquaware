import React, { useState } from "react";

const ForgotPassword = () => {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  const handleForgotPassword = async () => {
    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/forgot-password/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email }),
          credentials: "include",
        }
      );

      if (response.ok) {
        setMessage("Password reset email sent successfully!");
        setError("");
      } else {
        const data = await response.json();
        setError(data.error || "Something went wrong. Please try again.");
        setMessage("");
      }
    } catch (error) {
      setError("Failed to send the request. Please try again.");
      setMessage("");
    }
  };

  return (
    <div className="w-full h-screen flex flex-col items-center justify-center bg-n-8">
      <div className="w-full max-w-[400px] bg-n-1 rounded-lg shadow-lg p-8">
        <h1 className="text-2xl font-bold text-center text-n-8 mb-6">
          Forgot Password
        </h1>
        <p className="text-base text-center text-n-8 mb-6">
          Enter your email address to receive a password reset link.
        </p>

        {message && (
          <p className="text-green-500 text-center mb-4">{message}</p>
        )}
        {error && <p className="text-red-500 text-center mb-4">{error}</p>}

        <input
          type="email"
          placeholder="Email Address"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
        />

        <button
          onClick={handleForgotPassword}
          className="w-full bg-blue-500 text-white font-semibold rounded-md py-3 mt-4 hover:bg-blue-600"
        >
          Send Reset Link
        </button>
      </div>
    </div>
  );
};

export default ForgotPassword;
