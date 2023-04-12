import "@/styles/globals.css";
import { getDefaultWallets, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import { NotificationProvider } from "@web3uikit/core";
import { configureChains, createClient, WagmiConfig } from "wagmi";
import { goerli } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";
import { jsonRpcProvider } from "wagmi/providers/jsonRpc";

const localhost = {
  id: 31337,
  name: "Localhost",
  network: "localhost",
  iconUrl:
    "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyOCIgaGVpZ2h0PSIyOCIgZmlsbD0ibm9uZSI+PHBhdGggZmlsbD0iIzI1MjkyRSIgZmlsbC1ydWxlPSJldmVub2RkIiBkPSJNMTQgMjhhMTQgMTQgMCAxIDAgMC0yOCAxNCAxNCAwIDAgMCAwIDI4WiIgY2xpcC1ydWxlPSJldmVub2RkIi8+PHBhdGggZmlsbD0idXJsKCNhKSIgZmlsbC1vcGFjaXR5PSIuMyIgZmlsbC1ydWxlPSJldmVub2RkIiBkPSJNMTQgMjhhMTQgMTQgMCAxIDAgMC0yOCAxNCAxNCAwIDAgMCAwIDI4WiIgY2xpcC1ydWxlPSJldmVub2RkIi8+PHBhdGggZmlsbD0idXJsKCNiKSIgZD0iTTguMTkgMTQuNzcgMTQgMTguMjFsNS44LTMuNDQtNS44IDguMTktNS44MS04LjE5WiIvPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Im0xNCAxNi45My01LjgxLTMuNDRMMTQgNC4zNGw1LjgxIDkuMTVMMTQgMTYuOTNaIi8+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJhIiB4MT0iMCIgeDI9IjE0IiB5MT0iMCIgeTI9IjI4IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHN0b3Agc3RvcC1jb2xvcj0iI2ZmZiIvPjxzdG9wIG9mZnNldD0iMSIgc3RvcC1jb2xvcj0iI2ZmZiIgc3RvcC1vcGFjaXR5PSIwIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgaWQ9ImIiIHgxPSIxNCIgeDI9IjE0IiB5MT0iMTQuNzciIHkyPSIyMi45NiIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIHN0b3AtY29sb3I9IiNmZmYiLz48c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiNmZmYiIHN0b3Atb3BhY2l0eT0iLjkiLz48L2xpbmVhckdyYWRpZW50PjwvZGVmcz48L3N2Zz4K",
  nativeCurrency: {
    decimals: 18,
    name: "Ether",
    symbol: "ETH",
  },
  rpcUrls: {
    default: {
      http: ["http://localhost:8545"],
    },
  },
};

const { chains, provider } = configureChains(
  [goerli, /* localhost */],
  [
    // alchemyProvider({ apiKey: process.env.ALCHEMY_ID }),
    publicProvider(),
    // jsonRpcProvider({
    //   rpc: (chain) => ({ http: chain.rpcUrls.default.http[0] }),
    // }),
  ]
);

const { connectors } = getDefaultWallets({
  appName: "web3-godaddy",
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
});

export default function App({ Component, pageProps }) {
  return (
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains={chains} modalSize="compact" coolMode>
        <NotificationProvider>
          <Component {...pageProps} />
        </NotificationProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
}
