module KMPackages.Index.Msgs exposing (Msg(..))

import Jwt
import KMPackages.Common.Models exposing (Package)


type Msg
    = GetPackagesCompleted (Result Jwt.JwtError (List Package))
    | ShowHideDeletePackage (Maybe Package)
    | DeletePackage
    | DeletePackageCompleted (Result Jwt.JwtError String)
