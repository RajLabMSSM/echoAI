#' Run pre-trained \emph{SpliceAI} model
#'
#' Run the pre-trained \emph{SpliceAI} deep learning model to predict
#' splice-site alterations from genetic variants. Requires the
#' \code{spliceai} command-line tool to be installed and on the system
#' \code{PATH} (e.g. via \code{pip install spliceai}).
#'
#' @param vcf_path Path to the input VCF file.
#' @param output_path Path to the output VCF file.
#' @param reference_fasta Path to the reference genome FASTA file
#'   (must be unzipped).
#' @param gene_annotation Path to a gene annotation file, or one of
#'   \code{"grch37"} / \code{"grch38"} to use the GENCODE canonical
#'   annotations bundled with SpliceAI.
#' @param distance Maximum distance (in bases) between the variant and a
#'   gained/lost splice site. Defaults to 50.
#' @param mask Integer flag controlling score masking. When set to 1,
#'   masks scores representing annotated acceptor/donor gain and
#'   unannotated acceptor/donor loss. Defaults to 0 (no masking).
#'
#' @returns The exit code from the \code{spliceai} system call
#'   (invisibly).
#'
#' @export
#' @family SPLICEAI
#' @source
#' \url{https://github.com/Illumina/SpliceAI}
#' \doi{10.1016/j.cell.2018.12.015}
#' @examples
#' \dontrun{
#' SPLICEAI_run(
#'     vcf_path = "variants.vcf",
#'     output_path = "spliceai_predictions.vcf",
#'     reference_fasta = "hg19.fa",
#'     gene_annotation = "grch37"
#' )
#' }
SPLICEAI_run <- function(vcf_path = "./GWAS_converted.vcf",
                         output_path = "spliceai_predictions.vcf",
                         reference_fasta,
                         gene_annotation = "grch37",
                         distance = 50,
                         mask = 0) {

    cmd <- paste("spliceai",
                 "-I", vcf_path,
                 "-O", output_path,
                 "-R", reference_fasta,
                 "-A", gene_annotation,
                 "-D", distance,
                 "-M", mask)
    messager(cmd)
    res <- system(cmd)
    invisible(res)
}
