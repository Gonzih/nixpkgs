{ lib, fetchFromGitHub, buildGoModule }:


let
  channel = "edge";
in buildGoModule rec {
  pname = "linkerd-${channel}";
  version = "21.2.3";

  src = fetchFromGitHub {
    owner = "linkerd";
    repo = "linkerd2";
    rev = "${channel}-${version}";
    sha256 = "0vdp40c608l8v748fwblk6hbpscp9xnf00y12frnxc1c1mb6n34y";
  };

  vendorSha256 = "07k1vm93zga95hgcrf7na12gwv66n9qy9q65n010d6zsp0kiggpc";

  preBuild = ''
    go generate ./pkg/charts/static
    go generate ./jaeger/static
    go generate ./multicluster/static
    go generate ./viz/static
  '';

  buildFlagsArray = [ "-tags prod" ];
  runVend = true;
  doCheck = true;
  subPackages = [ "cli" ];

  meta = with lib; {
    description = "A service mesh for Kubernetes and beyond";
    homepage = "https://linkerd.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
