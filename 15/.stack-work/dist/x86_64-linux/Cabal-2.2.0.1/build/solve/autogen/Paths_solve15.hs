{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_solve15 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/dev/advent/15/.stack-work/install/x86_64-linux/lts-12.23/8.4.4/bin"
libdir     = "/home/dev/advent/15/.stack-work/install/x86_64-linux/lts-12.23/8.4.4/lib/x86_64-linux-ghc-8.4.4/solve15-0.1.0.0-5m4H8LxpDHMMfuT3UT3e7-solve"
dynlibdir  = "/home/dev/advent/15/.stack-work/install/x86_64-linux/lts-12.23/8.4.4/lib/x86_64-linux-ghc-8.4.4"
datadir    = "/home/dev/advent/15/.stack-work/install/x86_64-linux/lts-12.23/8.4.4/share/x86_64-linux-ghc-8.4.4/solve15-0.1.0.0"
libexecdir = "/home/dev/advent/15/.stack-work/install/x86_64-linux/lts-12.23/8.4.4/libexec/x86_64-linux-ghc-8.4.4/solve15-0.1.0.0"
sysconfdir = "/home/dev/advent/15/.stack-work/install/x86_64-linux/lts-12.23/8.4.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "solve15_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "solve15_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "solve15_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "solve15_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "solve15_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "solve15_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
