import React from "react";
import { useLocation } from "react-router-dom";
import { disablePageScroll, enablePageScroll } from "scroll-lock";
import Cookies from "js-cookie";
import Button from "./Button";
import MenuSvg from "../assets/svg/MenuSvg";
import { HamburgerMenu } from "./design/Header";
import { useState, useEffect } from "react";
import aquawareLogo from "../assets/aquaware.png";
import { useTranslation } from "react-i18next";

const Header = () => {
  const { t } = useTranslation();
  const { pathname, hash } = useLocation();
  const [openNavigation, setOpenNavigation] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    const refreshToken = Cookies.get("refresh_token");
    if (refreshToken) {
      setIsLoggedIn(true);
    } else {
      setIsLoggedIn(false);
    }
  }, []);

  const toggleNavigation = () => {
    if (openNavigation) {
      setOpenNavigation(false);
      enablePageScroll();
    } else {
      setOpenNavigation(true);
      disablePageScroll();
    }
  };

  const handleClick = () => {
    if (!openNavigation) return;

    enablePageScroll();
    setOpenNavigation(false);
  };

  return (
    <div
      className={`fixed top-0 left-0 w-full z-50  border-b border-n-6 lg:bg-n-8/90 lg:backdrop-blur-sm ${
        openNavigation ? "bg-n-8" : "bg-n-8/90 backdrop-blur-sm"
      }`}
    >
      <div className="flex items-center px-5 lg:px-7.5 xl:px-10 max-lg:py-4">
        <a className="block w-[12rem] xl:mr-8 flex items-center" href="/#hero">
          <img src={aquawareLogo} className="h-10" alt="Aquaware Logo" />
          <p className="m-4">Aquaware</p>
        </a>

        <nav
          className={`${
            openNavigation ? "flex" : "hidden"
          } fixed top-[5rem] left-0 right-0 bottom-0 bg-n-8 lg:static lg:flex lg:mx-auto lg:bg-transparent`}
        >
          <div className="relative z-2 flex flex-col items-center justify-center m-auto lg:flex-row">
            <a
              href="/#features"
              onClick={handleClick}
              className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                pathname + hash === "/#features"
                  ? "z-2 lg:text-n-1"
                  : "lg:text-n-1/50"
              } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.features")}
            </a>
            <a
              href="/#pricing"
              onClick={handleClick}
              className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                pathname + hash === "/#pricing"
                  ? "z-2 lg:text-n-1"
                  : "lg:text-n-1/50"
              } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.pricing")}
            </a>
            <a
              href="/#app"
              onClick={handleClick}
              className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                pathname + hash === "/#app"
                  ? "z-2 lg:text-n-1"
                  : "lg:text-n-1/50"
              } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.officialApp")}
            </a>
            <a
              href="/articles"
              onClick={handleClick}
              className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                pathname + hash === "/articles"
                  ? "z-2 lg:text-n-1"
                  : "lg:text-n-1/50"
              } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.articles")}
            </a>
            <a
              href="/docs/index.html"
              onClick={handleClick}
              className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                pathname === "/docs/index.html"
                  ? "z-2 lg:text-n-1"
                  : "lg:text-n-1/50"
              } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.apiDocumentation")}
            </a>
            <a
              href="https://github.com/kesslermatics/Aquaware"
              target="_blank"
              rel="noreferrer noopener"
              onClick={handleClick}
              className={`block relative font-code text-2xl uppercase text-n-1/50 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold  lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.github")}
            </a>
            {openNavigation && (
              <>
                {isLoggedIn ? (
                  <a
                    href="/dashboard"
                    onClick={handleClick}
                    className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                      pathname + hash === "/dashboard"
                        ? "z-2 lg:text-n-1"
                        : "lg:text-n-1/50"
                    } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
                  >
                    {t("header.links.profile")}
                  </a>
                ) : (
                  <>
                    <a
                      href="/signup"
                      onClick={handleClick}
                      className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                        pathname + hash === "/signup"
                          ? "z-2 lg:text-n-1"
                          : "lg:text-n-1/50"
                      } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
                    >
                      {t("header.links.createAccount")}
                    </a>
                    <a
                      href="/login"
                      onClick={handleClick}
                      className={`block relative font-code text-2xl uppercase text-n-1 transition-colors hover:text-color-1 px-6 py-6 md:py-8 lg:-mr-0.25 lg:text-xs lg:font-semibold ${
                        pathname + hash === "/login"
                          ? "z-2 lg:text-n-1"
                          : "lg:text-n-1/50"
                      } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
                    >
                      {t("header.links.signIn")}
                    </a>
                  </>
                )}
              </>
            )}
          </div>

          <HamburgerMenu />
        </nav>

        {isLoggedIn ? (
          <>
            <Button className="hidden lg:flex" href="/dashboard">
              {t("header.links.profile")}
            </Button>
            <Button
              className="ml-auto lg:hidden"
              px="px-3"
              onClick={toggleNavigation}
            >
              <MenuSvg openNavigation={openNavigation} />
            </Button>
          </>
        ) : (
          <>
            <a
              href="/signup"
              className="button hidden mr-8 text-n-1/50 transition-colors hover:text-n-1 lg:block"
            >
              {t("header.links.createAccount")}
            </a>
            <Button className="hidden lg:flex" href="/login">
              {t("header.links.signIn")}
            </Button>
            <Button
              className="ml-auto lg:hidden"
              px="px-3"
              onClick={toggleNavigation}
            >
              <MenuSvg openNavigation={openNavigation} />
            </Button>
          </>
        )}
      </div>
    </div>
  );
};

export default Header;
