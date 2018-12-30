{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE ViewPatterns #-}
import Data.Char (intToDigit)
import qualified Data.Set as S
import Data.Functor.Identity
import Data.Functor
import Data.List
import Data.List.Index
import Data.Either
import Control.Applicative
import Control.Arrow
import Control.Monad
import  Data.Vector (Vector,(!),(//))
import qualified Data.Vector as V
import qualified Data.Map as M
import Control.Monad.Reader
import Control.Concurrent.STM
import Control.Lens
import Test.Hspec
import Data.Maybe
import Say
import Debug.Trace
import qualified Data.Set.Extra as SE
import System.Process (system)

data Species = E | G
    deriving (Eq, Ord)
enemy G = E
enemy E = G
instance Show Species
    where
        show E = "E"
        show G = "G"
type Health = Int
newtype Units = Units {unit :: M.Map (Int,Int) (Species,Health)}
    deriving (Show,Eq,Ord)
data Cave = Cave {caveArray :: !(Vector (Vector Char)), caveUnits :: Units}

data Env = Env 
    { envElfPower :: Int,
      envCave :: Cave}
makeLensesWith camelCaseFields ''Env
makeLensesWith camelCaseFields ''Cave

main :: IO ()
main = do 
    str <- readFile "input"

    hspec $
        describe "Retrieval" $ 
            it "works" $ do
                let env = Env {envElfPower = 3, envCave = makeCave str}
                res <- runReaderT  
                    (do 
                        env <- ask
                        result <- myiterate (\a -> do
                            liftIO $ system "tput home"
                            sayShow a
                            liftIO $ print $ M.size (unit $ caveUnits a)
                            --liftIO getLine
                            return $ turn a
                            ) (env^.cave)

                        let result' = last $ take 200 result
                        sayShow result'
                        return result'
                    )
                    env
                let Cave a _ = res 
                print "hi"
                a `shouldBe` a
    return ()

myiterate :: Monad m => (Cave -> m Cave) -> Cave -> m [Cave]
myiterate f a 
        | done a = return [a]
        | otherwise = do
            a' <- f a
            rest <- myiterate f a'
            return $ a : rest

done (Cave _ (Units u))= M.null elves || M.null goblins
    where 
    elves = M.filter (\(s,h) -> s == E) u
    goblins = M.filter (\(s,h) -> s == G) u

turn :: Cave -> Cave
turn cave@(Cave walls a@(Units u)) = let 
    t = M.foldlWithKey (\cave@(Cave _ a') k (v,_) -> takeTurn cave a' k v) cave u
    in t

takeTurn :: Cave -> Units -> (Int,Int) -> Species -> Cave
takeTurn cave a@(Units u) k v = let
    (cave',new_pos) = move cave a k v
    t = attack cave' new_pos v
    in case M.lookup k u of
        Nothing -> cave
        Just (s,health) -> t

attack :: Cave -> (Int,Int) -> Species -> Cave
attack c@(Cave cave (Units past)) pos species = case t of
    [] -> c
    a@(y,x):_ -> let
                    Just (other,other_health) = M.lookup a past
                 in setCave a e (other_health - power species) c
    where
        power G = 3
        power E = 3
        Just (self,myhealth) = M.lookup pos past
        e = head $ show $ enemy species
        enemies = M.filter (\(a,_) -> a == enemy self ) past
        total = sort $ map (\a-> (snd $ fromJust $ M.lookup a past,a)) $ filter (\(y,x) -> cave ! y ! x == e ) $ adjacent pos
        t = map snd total

setCave :: (Int,Int) -> Char -> Health -> Cave -> Cave
setCave (y,x) value health c@(Cave cave (Units map)) 
    | health > 0 = Cave cave' $ map' value
    | otherwise = traceShow ("died",value,(y,x)) $ setCave (y,x) '.' 1 c
    where
        cave' =cave //  [(y, (cave ! y) // [(x,value)])] 
        map' 'G' = Units $ M.insert (y,x) (G,health) map
        map' 'E' = Units $ M.insert (y,x) (E,health) map
        map' '0' = Units $ M.delete (y,x) map
        map' '.' = Units $ M.delete (y,x) map
        map' _   = Units map 

getCave :: (Int,Int) -> Cave -> Char
getCave (y,x) (Cave cave (Units _)) = cave ! y ! x

adjacent (y,x) = [ (y+1,x), (y,x-1), (y,x+1), (y-1,x)  ]
move :: Cave -> Units -> (Int,Int) -> Species -> (Cave,(Int,Int))
move c@(Cave cave (Units past)) (Units past_old ) key@(y,x) race =
    let 
        Just (self,health) = M.lookup key past
        enemies = M.filter (\(a,_) -> a == enemy self ) past
        targets = filter (\(y,x) -> (cave ! y ! x) /= '#') $ join $ M.keys $ M.mapKeys adjacent enemies
        targetsS = S.fromList targets

        b_star :: (Int,Int) -> ((Int,Int) , (Int, Int))
        b_star pos_orig
                | S.member pos_orig targetsS = (pos_orig,pos_orig)
                | otherwise             = go_star S.empty (S.singleton pos_orig) $ M.singleton pos_orig pos_orig
                where 
            go_star :: S.Set (Int,Int) -> S.Set (Int,Int) -> M.Map (Int,Int) (Int,Int) -> ((Int,Int),(Int,Int))
            go_star visited queue paths
                    | S.null queue = (pos_orig,pos_orig)
                    | otherwise =
                    let
                nexts = S.filter (\(y,x) -> (cave ! y !x ) == '.') . SE.flatten $ S.map (S.fromList . adjacent) queue
                queue' = S.filter (`S.notMember` visited) nexts
                visited' = S.union visited queue'
                targetFound = find (`S.member` targetsS) queue'

                nextsW = S.map (\a -> (a,adjacent a)) queue
                queueW' = S.map (\(a,b) -> (a,filter (`S.notMember` visited) b)) nextsW

                pathsW' = foldl' (\p (k,vs) -> 
                            foldl' (flip (M.alter (f k)) ) p vs
                        ) paths queueW'

                t p l = case M.lookup p pathsW' of
                    Just p' | p' == p -> l
                            | otherwise -> t p' (p:l)
                    Nothing -> error "bad path"

                t' pos = s . reverse $ t pos []
                s [] = error "bad path list"
                s [a] = a
                s [a,b] = b
                s (a:r) = s r

                queueMap = M.filter (`elem` queue) paths
                paths' = M.foldlWithKey (\p k v -> M.alter (f v) k p) paths queueMap
                f v Nothing    = Just v
                f v (Just pos) = Just pos

                in case targetFound of
                    Just pos -> (pos, t' pos)
                    Nothing  -> go_star visited' queue' pathsW'

        (original, new_position)  = b_star key

        anotherCave = setCave key '.' 1 c
        Cave anotherCave' _= setCave new_position (t race) health anotherCave

        new_path = M.insert new_position (race,health) (M.delete key past)
        t G = 'G'
        t E = 'E'

    in (Cave anotherCave' $ Units new_path,new_position)


instance Show Cave where
    show  (Cave cave (Units u))= unlines result
        where 
              line :: [(Char,(Int,Int))] -> String
              line a = map fst a ++ " " ++ healths ++ replicate (40 - length healths) ' '
                where
                  filtered = filter (\(b,c) -> b /= '#' && b /= '.') a
                  healths :: String
                  healths = join $ map (\(b,c) -> show $ fromJust $ M.lookup c u) filtered
              temp  = V.toList cave
              temp'  = map V.toList temp
              ztemp = zip [0..] temp'
              ztemp' = map (\(i,a) -> zip a (zip (repeat i) [0..])) ztemp
              result = fmap line ztemp'

makeCave :: String -> Cave
makeCave str = flip Cave ( makeUnits str) . V.fromList . fmap V.fromList $ lines str

makeUnits :: String -> Units
makeUnits = Units . M.fromList . stuff
    where
        stuff :: String -> [ ((Int,Int),(Species,Health)) ]
        stuff str = do
            (row, line) <- zip [0..] $ lines str
            (column, char) <- zip [0..] line
            let go y x 'G' = [((y,x),(G,200)   )]
                go y x 'E' = [((y,x),(E,200)   )]
                go _ _ _ = []
            go row column char

