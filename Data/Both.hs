{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DeriveTraversable          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- | The 'Both' type and operations. Like 'Maybe', but not.
module Data.Both where

import Control.Applicative
import Control.Monad
import Data.Data
import Data.Foldable
import Data.Maybe
import Data.Monoid hiding ((<>))
import Data.Semigroup
import Data.Traversable
import GHC.Generics

newtype Both a = Both { getBoth :: Maybe a }
  deriving (Eq, Ord, Read, Show, Data, Typeable, Generic, Generic1, Functor, Applicative, Alternative, Monad, MonadPlus, Foldable, Traversable)

-- | The '(<>)' for 'Maybe' is 'Just' if /either/ of the operands
-- are, whereas here /both/ must be.
instance Semigroup a => Semigroup (Both a) where
  Both (Just x) <> Both (Just y) = Both . Just $ x <> y
  _ <> _ = Both Nothing

instance (Monoid a, Semigroup a) => Monoid (Both a) where
  mempty  = Both $ Just mempty
  mappend = (<>)


-- | The 'both' function takes a default value, a function, and a
-- 'Both' value. If the inner 'Maybe' value is 'Nothing', the function
-- returns the default value. Otherwise, it applies the function to
-- the value inside the 'Just' and returns the result.
both :: b -> (a -> b) -> Both a -> b
both z f = maybe z f . getBoth

-- | The 'fromBoth' function takes a default value and a 'Both'
-- value. If the inner 'Maybe' is 'Nothing', it returns the default
-- value; otherwise, it returns the value contained within.
fromBoth :: a -> Both a -> a
fromBoth z = fromMaybe z . getBoth
