import { ConnectButton } from "@rainbow-me/rainbowkit";
import Image from "next/image";
import Link from "next/link";

const Navigation = () => {
  return (
    <nav className="flex items-center justify-between p-4">
      <div className="flex items-center gap-16">
        <div className="flex items-center gap-2">
          <Image
            src="/ethereum_logo.svg"
            alt="Nothing"
            width={25}
            height={25}
          />
          <p className="font-bold text-xl">Web3 GoDaddy</p>
        </div>
        <ul className="flex gap-6">
          <Link href="/">Domain Names</Link>
          <Link href="/">Website & Hosting</Link>
          <Link href="/">Commerce</Link>
          <Link href="/">Email & Marketing</Link>
        </ul>
      </div>
      <div>
        <ConnectButton
          showBalance={{
            largeScreen: true,
            smallScreen: false,
          }}
        />
      </div>
    </nav>
  );
};

export default Navigation;
