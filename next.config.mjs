/** @type {import('next').NextConfig} */
const nextConfig = {
  // Use standalone output for Docker/Render, but disable it on Vercel to prevent NFT trace errors
  output: process.env.VERCEL ? undefined : 'standalone',
  images: {
    unoptimized: true,
  }
};

export default nextConfig;
