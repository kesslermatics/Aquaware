import React, { useState } from "react";
import confetti from "canvas-confetti";
import Heading from "./Heading";
import Section from "./Section";
import { useTranslation } from "react-i18next";

const TailoredTool = () => {
  const { t } = useTranslation();
  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    organization: "",
    email: "",
    message: "",
  });
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/feedback/tailored-request/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(formData),
        }
      );

      if (response.ok) {
        confetti({
          particleCount: 150,
          spread: 60,
          origin: { y: 0.6 },
        });
        setIsSubmitted(true);
        setErrorMessage("");
      } else {
        const data = await response.json();
        setErrorMessage(data.detail || t("tailoredTool.error"));
      }
    } catch (error) {
      console.error("Error submitting form:", error);
      setErrorMessage(t("tailoredTool.submitError"));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Section crosses>
      <div className="max-w-3xl mx-auto p-6 rounded-lg">
        <Heading title={t("tailoredTool.title")} />
        {!isSubmitted ? (
          <>
            <p className="mb-6">{t("tailoredTool.description")}</p>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="flex flex-wrap gap-4">
                <div className="flex-1">
                  <label htmlFor="firstName" className="block font-medium mb-1">
                    {t("tailoredTool.firstNameLabel")}{" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    id="firstName"
                    name="firstName"
                    value={formData.firstName}
                    onChange={handleChange}
                    required
                    className="w-full p-2 border rounded bg-n-6"
                  />
                </div>
                <div className="flex-1">
                  <label htmlFor="lastName" className="block font-medium mb-1">
                    {t("tailoredTool.lastNameLabel")}{" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    id="lastName"
                    name="lastName"
                    value={formData.lastName}
                    onChange={handleChange}
                    required
                    className="w-full p-2 border rounded bg-n-6"
                  />
                </div>
              </div>
              <div>
                <label
                  htmlFor="organization"
                  className="block font-medium mb-1"
                >
                  {t("tailoredTool.organizationLabel")}
                </label>
                <input
                  type="text"
                  id="organization"
                  name="organization"
                  value={formData.organization}
                  onChange={handleChange}
                  className="w-full p-2 border rounded bg-n-6"
                />
              </div>
              <div>
                <label htmlFor="email" className="block font-medium mb-1">
                  {t("tailoredTool.emailLabel")}{" "}
                  <span className="text-red-500">*</span>
                </label>
                <input
                  type="email"
                  id="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                  className="w-full p-2 border rounded bg-n-6"
                />
              </div>
              <div>
                <label htmlFor="message" className="block font-medium mb-1">
                  {t("tailoredTool.messageLabel")}{" "}
                  <span className="text-red-500">*</span>
                </label>
                <textarea
                  id="message"
                  name="message"
                  value={formData.message}
                  onChange={handleChange}
                  required
                  rows="4"
                  className="w-full p-2 border rounded bg-n-6"
                ></textarea>
              </div>
              {errorMessage && <p className="text-red-500">{errorMessage}</p>}
              <button
                type="submit"
                className="bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600 flex items-center justify-center"
                disabled={isLoading}
              >
                {isLoading ? (
                  <svg
                    className="animate-spin h-5 w-5 text-white"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    ></circle>
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8v8H4z"
                    ></path>
                  </svg>
                ) : (
                  t("tailoredTool.submitButton")
                )}
              </button>
            </form>
          </>
        ) : (
          <p className="text-green-500 text-center">
            {t("tailoredTool.successMessage")}
          </p>
        )}
      </div>
    </Section>
  );
};

export default TailoredTool;
