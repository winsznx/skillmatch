/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    transpilePackages: ['@skillmatch/shared', '@skillmatch/base-adapter', '@skillmatch/stacks-adapter'],
};

export default nextConfig;
