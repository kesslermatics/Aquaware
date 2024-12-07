import { useRouter } from "next/router";
import { disablePageScroll, enablePageScroll } from "scroll-lock";
import Cookies from "js-cookie";
import Button from "./Button";
import MenuSvg from "../assets/svg/MenuSvg";
import { HamburgerMenu } from "./design/Header";
import { useState, useEffect } from "react";
import aquawareLogo from "../assets/aquaware.png";
import { useTranslation } from "next-i18next";

const Header = () => {
  const { t } = useTranslation();
  const router = useRouter(); // Replaces useLocation
  const { pathname, asPath } = router; // Current path and full path with query
  const [openNavigation, setOpenNavigation] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    const refreshToken = Cookies.get("refresh_token");
    setIsLoggedIn(!!refreshToken); // Simplified logic
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
    if (openNavigation) {
      enablePageScroll();
      setOpenNavigation(false);
    }
  };

  const isActive = (targetPath) => pathname + asPath === targetPath;

  return (
    <div
      className={`fixed top-0 left-0 w-full z-50 border-b border-n-6 lg:bg-n-8/90 lg:backdrop-blur-sm ${
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
                isActive("/#features")
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
                isActive("/#pricing")
                  ? "z-2 lg:text-n-1"
                  : "lg:text-n-1/50"
              } lg:leading-5 lg:hover:text-n-1 xl:px-12`}
            >
              {t("header.links.pricing")}
            </a>
            {/* Add other links here following the same pattern */}
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
